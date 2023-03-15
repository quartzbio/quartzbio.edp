  JSON <- "application/json"

format_auth_header <- function(secret) {
  token_type <- if (looks_like_api_key(secret)) 'Token' else 'Bearer'
  c(Authorization = paste(token_type, secret, sep = " "))
}


preprocess_api_params <- function(
  exclude = c('conn', 'limit', 'page'), 
  match_args = list(
    capacity = c('small', 'medium', 'large', 'xlarge'),
    commit_mode = c('append', 'overwrite', 'upsert', 'delete'),
    data_type = c('auto', 'boolean', 'date', 'double', 'float', 'integer', 'long', 'object', 
      'string', 'text', 'blob'),
    object_type = c('file', 'folder', 'dataset'),
    status = TASK_STATUS,
    vault_type = c('user', 'general'),
    storage_class =  c('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')
  )
) {
  env <- parent.frame()
  # remove common args
  keys <- setdiff(ls(env), exclude)
  values <- mget(keys, env)

  params <- list()
  for (key in keys) {
    value <- get(key, env)
    args <- match_args[[key]]
    if (length(value)) {
      if (length(args)) {
        value <- match.arg(value, args)
      }
      if (grepl('id$', key)) {
        value <- id(value)
      }
      params[[key]] <- value
    }
  }
  
  params
}

# N.: param ... is silently ignored
# create the request params involved in referencing a piece of data

request_pointer <- function(offset = NULL, page = NULL, limit = NULL, ...) {
  .die_if(length(offset) && length(page), 'you can not set both "page" AND "offset"')

  list(offset = offset, page = page, limit = limit)
}

# N.: param ... is silently ignored
# create the request options
request_options <- function(content_type = "application/json",
                            raw = FALSE,
                            postprocess = TRUE,
                            encoding = "UTF-8",
                            verbose = getOption('quartzbio.edp.verbose', TRUE),
                            parse_fast = getOption('quartzbio.edp.use_fast_parser', require('RcppSimdJson')),
                            parse_as_df = FALSE, ...)
{
  list(
    content_type = content_type,
    raw = raw,
    postprocess = postprocess,
    encoding = encoding,
    verbose = verbose,
    parse_fast = parse_fast,
    parse_as_df = parse_as_df
  )
}

# Private API request method.
# parse options: 
# - parse_fast
# -parse_as_df
request_edp_api <- function(method, path = '',  params = list(), 
  pointer = request_pointer(...),
  options = request_options(...),  
  uri = file.path(conn$host, path), 
  conn = get_connection(), ...)
{
  check_connection(conn)

  ### params
  if (length(pointer$limit)) params$limit <- pointer$limit
  if (length(pointer$page)) params$page <- pointer$page
  if (length(pointer$offset)) {
    params$offset <- pointer$offset
    if (params$offset < 0) return(NULL)
  }

  query <- list()
  body <- list()
  if (length(params)) {
    if (method == 'GET') {
      query <- params
    } else {
      body <- params
    }
  }

  ### headers
  headers <- c(
    "Accept" = JSON,
    "Accept-Encoding" = "gzip,deflate",
    "Content-Type" = options$content_type,
    c(format_auth_header(conn$secret))
  )

  ### URI
  if (substring(path, 1, 1) == "/") {
    path <- substring(path, 2)
  }
  force(uri)
  if (options$verbose) {
    msg <- sprintf('%s %s...', method, uri)
    message(msg)
  }

  ### User Agent
  useragent <- sprintf(
    "QuartzBio EDP R Client %s [%s %s]",
    packageVersion("quartzbio.edp"),
    R.version$version.string,
    R.version$platform
  )
  config <- httr::config(useragent = useragent)

  ### encoding
  encode <- "form"
  if (options$content_type == JSON) {
    if (length(body) > 0) {
      body <- jsonlite::toJSON(body, auto_unbox = TRUE, null = "null")
      encode <- "json"
    }
  }

  ### actual API request
  res <- httr::VERB(
    method,
    uri,
    httr::add_headers(headers),
    config = config,
    body = body,
    query = query,
    encode = encode)
  if (options$raw) return(res)
  # N.B: may die with an appropriate error message
  ret <- check_httr_response(res)
  if (!isTRUE(ret)) return(ret)

  content <- if (options$parse_fast) {
    max_simplify_lvl <- if (options$parse_as_df) 'data_frame' else 'list'
    RcppSimdJson::fparse(res$content, max_simplify_lvl = max_simplify_lvl)

  } else {
    httr::content(res, encoding = options$encoding, simplifyDataFrame = options$parse_as_df)
  }

  if (options$postprocess) {
    args <- list(method = method, uri = uri, params = params, options = options, conn = conn)
    fetchers <- create_fetchers(args, pointer)
    content <- postprocess_response(content, is_df = options$parse_as_df, conn = conn, fetchers = fetchers)
  }

  content
}

# function dedicated to request_edp_api(). Will automatically create the next and prev fetchers 
create_fetchers <- function(args, pointer) {
  if (!length(pointer$limit)) return(NULL)
  if (!length(pointer$offset)) pointer$offset <- 0L

  fetcher <- function(x) {
    args$pointer <- x
    do.call(request_edp_api, args)
  }

  fetch_next <- function() {
    x <- pointer
    x$offset <- x$offset + x$limit
    fetcher(x)
  }
  fetch_prev <- function() {
    x <- pointer
     x$offset <- x$offset - x$limit
    fetcher(x)
  }

  list(`next` = fetch_next, `prev` = fetch_prev)
}

setup_prev_next <- function(x, fun, limit, offset) {
  if (!length(x)) return(x)
  # fun2 <- function(limit, page) setup_prev_next(fun(limit, page), fun, limit, page)

  attr(x, 'next') <- function() { fun(limit, offset + limit)}
  attr(x, 'prev') <- function() { fun(limit, offset - limit) }

  x
}



# process a list of params, which may have been set or not.
# apply the constraints (unique, empty) to check those params, and return the appropriate ones
# a param may be a sublist, in which case it is deemed set iff all its items are set
process_by_params <- function(by,  unique = !empty, empty = FALSE) {
  keys <- names(by)
  .die_unless(length(keys) == length(by) && all(nzchar(keys)), '"by" must be a named list')
  .die_unless(length(by) > 0, '"by" can not be empty')
    # also process sublists
  .is_set <- function(x) {
    if (is.list(x)) { # sublist
      # a sublist is set if all its items are set, otherwise it is an error
      nb_set <- sum(lengths(x) > 0)
      if (nb_set == 0) return(FALSE)
      .die_unless(nb_set == length(x), 'all items "%s" must be set', names(x))
      return(TRUE)
    }

    # a non-list item is set iff it is a scalar
    length(x) == 1
  }
  with_values <- unlist(lapply(by, .is_set), recursive = FALSE, use.names = FALSE)

  # number of params which have been set/given
  nb_set <- sum(with_values)

  .die_unless(!unique || nb_set == 1, 'you must give exactly one parameter among %s', keys)
  .die_if(nb_set == 0 && !empty, 'you must give at least one parameter among %s', keys)
  if (nb_set == 0) return(list())

  params <- list()
  for (key in keys[with_values]) {
    value <- by[[key]]
    if (endsWith(key, 'id')) value <- unclass(id(value))
    if (is.list(value)) params <- c(params, value) else params[[key]] <- value
  }

  params
}

# do a API request based on the existence of the params in the "by" named list:
#  if all==FALSE, and id is not set, returns only the first item
fetch_by <- function(path, by, conn, all = FALSE, unique = !empty, empty = FALSE, ...) {
  params <- if (length(by)) process_by_params(by, unique = unique, empty = empty) else list()

  # if "id" is in params, ajust the path and remove it from the params
  id <- params$id
  if (length(id)) {
    path <- file.path(path, id)
    params$id <- NULL
  }

  o <- request_edp_api('GET', path, conn = conn,  params = params, ...)

  if (!all) {
    if (!length(id)) {
      if (!length(o)) return(NULL)
      o <- o[[1]]
    }
  }

  o
}
