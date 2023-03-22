  JSON <- "application/json"

format_auth_header <- function(secret) {
  token_type <- if (looks_like_api_key(secret)) 'Token' else 'Bearer'
  c(Authorization = paste(token_type, secret, sep = " "))
}


preprocess_api_params <- function(
  exclude = c('conn', 'limit', 'page', 'offset'), 
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

request_pointer <- function(offset = NULL, page = NULL, limit = NULL, total = NULL, ...) {
  .die_if(length(offset) && length(page), 'you can not set both "page" AND "offset"')

  list(offset = offset, page = page, limit = limit, total = total)
}

# N.: param ... is silently ignored
# create the request options
request_options <- function(content_type = "application/json",
                            raw = FALSE,
                            postprocess = TRUE,
                            encoding = "UTF-8",
                            verbose = getOption('quartzbio.edp.verbose', TRUE),
                            parse_fast = getOption('quartzbio.edp.use_fast_parser', require('RcppSimdJson')),
                            parse_as_df = FALSE, 
                            retries = 3,
                            default_wait = 10,
                            ...)
{
  list(
    content_type = content_type,
    raw = raw,
    postprocess = postprocess,
    encoding = encoding,
    verbose = verbose,
    parse_fast = parse_fast,
    parse_as_df = parse_as_df,
    retries = retries,
    default_wait = default_wait
  )
}

# wrapper on httr::VERB with additional features: support for http code 429 and the "retry-after"
# header value
send_request <- function(..., fake_response = NULL, retries = 3, default_wait = 10) {
  res <- if (length(fake_response)) fake_response else httr::VERB(...)
  
  if (!length(res) || !'status_code' %in% names(res) || res$status_code != 429) return(res)

  ### too many requests --> that's our business to manage that
  # defensive programming
  .die_unless(is.numeric(retries), 'param "retries" must be numeric')
  .die_unless(is.numeric(default_wait), 'param "default_wait" must be numeric')

  .die_unless(retries > 0, 
    'received a "Too many requests" response (429) but retries are exhausted, giving up...')
  
  retry_after <- res$headers[["retry-after"]] %IF_EMPTY_THEN% default_wait
  wait <- retry_after * (stats::runif(1) + 1) # add some jitter
  msg('received a "Too many requests" response (429). will retry in %ss...', wait)

  Sys.sleep(wait)

  send_request(..., fake_response = fake_response, retries = retries - 1, default_wait = default_wait)
}

# Private API request method.
# wrapper for request_edp_api_no_pager that provides a pager for the request
# i.e. the ability to fetch the other pages of data, either based on the "page" API param
# or on the "offset" API param
# the pager will be stored as the "pager" attribute, and is a function such as: 
# - pager() return the page index information
# - pager(NULL) return initial query
# - pager(i) returns the page #i of data, even if it has to use the "offset" to achieve that 
request_edp_api <- function(method, api, 
  params = list(),  
  options = request_options(...),  
  pointer = request_pointer(...),
  conn = get_connection(),
  ...)
{
  # pointer: NB: we only add page and offset params if > 0. 
  # But we still use them to determine if we are page-based, offset-based or none 
  # the 
  if (length(pointer$limit)) params$limit <- pointer$limit
  offset <- pointer$offset
  page <- pointer$page

  index_name <- 'page'
  index_default <- 1L
  USE_OFFSET <- options$parse_as_df

  # will be defined later
  PAGE_INDEX <- NULL
  SIZE <- NULL

  pager <- function(index, offset = NULL, page = NULL) {
    # N.B: for the first call, page_index is not initialized but index == NULL
    if (missing(index)) return(PAGE_INDEX)

    # initial values
    if (length(offset)) {
      params$offset <- offset
    } else if (length(page)) {
      params$page <- page
    } else {
    # use default from params if index == NULL
      if (!.empty(index)) {
        # update index
        PAGE_INDEX$index <- index 

        # we have an index
        if (USE_OFFSET) { # convert if to offset if needed
          params$offset <- page_to_offset(index, SIZE)
        } else {
          params$page <- index
        }
      }
    }

    res <- request_edp_api_no_pager(method, api, params = params, options = options, conn = conn)
    if (!length(res)) return(res)

    ### set pager
    current_fun <- sys.function()
    # create new closure to store new value of PAGE_INDEX
    attr(res, 'pager') <- function(index) { 
      if (missing(index)) return(PAGE_INDEX)
      current_fun(index)
    }

    res
  }

  # initial request
  res <- pager(NULL, offset = offset, page = page)

  # N.B: sometimes the total can be explicitely given with the request, it ends up in pointer$total
  total <- attr(res, 'total') %UNLESS_TRUE_INT% pointer$total
  if (!length(total) || is.na(total)) {
    # remove pager
    attr(res, 'pager') <- NULL
    return(res)
  }

  # now we can at last initialize size and total
  SIZE <- if (is.data.frame(res)) nrow(res) else length(res)
  # fix for API bug, cf https://precisionformedicine.atlassian.net/browse/SBP-527
  # if (length(total) && is.na(total)) {
  #   object_id <- attr(res, "object_id")
  #   if (length(object_id)) {
  #     warning('got null "total" from API, fetching instead of number of records')
  # }

  index <- 1L
  if (USE_OFFSET) {
    if (length(offset))
      index <- offset_to_page(offset, SIZE)
  } else {
    if (length(page))
      index <- page
  }

  nb_pages <- ceiling(total / SIZE)
  PAGE_INDEX <- list(index = index, nb = nb_pages, total = total)

  res
}

request_edp_api_no_pager <- function(method, path = '',  params, options,
  uri = file.path(conn$host, path), 
  conn = get_connection(), 
  fake_response = NULL)
{
  check_connection(conn)

  ### params

  # pointer: NB: we only add page and offset params if > 0. 
  # But we still use them to determine if we are page-based, offset-based or none 
  # the 
  # if (length(pointer$limit)) params$limit <- pointer$limit
  # page <- pointer$page
  # offset <- pointer$offset
  # if (length(page) && page > 0) params$page <- page
  # if (length(offset) && offset > 0) params$offset <- offset
  
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
  res <- send_request(  
    verb = method,
    url = uri,
    httr::add_headers(headers),
    config = config,
    body = body,
    query = query,
    encode = encode,
    fake_response = fake_response,
    retries = options$retries,
    default_wait = options$default_wait
  )
  if (options$raw) return(res)
  # N.B: may die with an appropriate error message
  ret <- check_httr_response(res)
  if (!isTRUE(ret)) return(ret)

  content <- if (options$parse_fast) {
    max_simplify_lvl <- if (options$parse_as_df) 'data_frame' else 'list'
    RcppSimdJson::fparse(res$content, max_simplify_lvl = max_simplify_lvl, int64_policy = "string")

  } else {
    httr::content(res, encoding = options$encoding, simplifyDataFrame = options$parse_as_df)
  }

  if (options$postprocess) {
    args <- list(method = method, uri = uri, params = params, options = options, conn = conn)
    content <- postprocess_response(content, is_df = options$parse_as_df, conn = conn)
  }

  content
}


# # function dedicated to request_edp_api(). Will automatically create the next and prev fetchers 
# create_fetchers <- function(args, pointer) {
#   if (!length(pointer$limit)) return(NULL)
#   if (!length(pointer$offset)) pointer$offset <- 0L

#   fetcher <- function(x) {
#     args$pointer <- x
#     do.call(request_edp_api, args)
#   }

#   fetch_next <- function() {
#     x <- pointer
#     x$offset <- x$offset + x$limit
#     fetcher(x)
#   }
#   fetch_prev <- function() {
#     x <- pointer
#      x$offset <- x$offset - x$limit
#     fetcher(x)
#   }

#   list(`next` = fetch_next, `prev` = fetch_prev)
# }

# setup_prev_next <- function(x, fun, limit, offset) {
#   if (!length(x)) return(x)
#   # fun2 <- function(limit, page) setup_prev_next(fun(limit, page), fun, limit, page)

#   attr(x, 'next') <- function() { fun(limit, offset + limit)}
#   attr(x, 'prev') <- function() { fun(limit, offset - limit) }

#   x
# }



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
