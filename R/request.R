  JSON <- "application/json"

format_auth_header <- function(secret) {
  token_type <- if (looks_like_api_key(secret)) 'Token' else 'Bearer'
  c(Authorization = paste(token_type, secret, sep = " "))
}

# try to parse some details about an API error, as provided by the API in the response
get_api_response_error_message <- function(res, default_message = '') {
  parsed <- try(httr::content(res), silent = TRUE)
  if (.is_error(parsed)) return('Error parsing API response')
  if (!length(parsed)) return(default_message)

  msg <- default_message
  if ("details" %in% names(parsed)) {
    msg <- parsed$details
  } else {
    # backwards compatibility
    msg <- paste0(unlist(parsed), collapse = ', ')
  }
  
  msg
}

preprocess_api_params <- function(
  exclude = c('conn', 'limit', 'page'), 
  match_args = list(
    capacity = c('small', 'medium', 'large', 'xlarge'),
    commit_mode = c('append', 'overwrite', 'upsert', 'delete'),
    data_type = c('auto', 'boolean', 'date', 'double', 'float', 'integer', 'long', 'object', 
      'string', 'text', 'blob'),
    object_type = c('file', 'folder', 'dataset'),
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



# either die, return TRUE if all good, or the early return value
# Error Code 	Meaning 	Description
# 400 	Bad Request 	Your request was malformed
# 401 	Unauthorized 	Your API key or token is invalid
# 403 	Forbidden 	Your API key or token is not valid for this type of request
# 404 	Not Found 	The specified resource could not be found
# 405 	Method Not Allowed 	Your request used an invalid method
# 429 	Too Many Requests 	You have reached the rate limit
# 500 	Internal Server Error 	We had a problem with our server
# 503 	Service Unavailable 	We are temporarily offline for maintenance
check_httr_response <- function(res) {
  status <- res$status
  # 204: no content, 301: moved permanently, 302: Moved Temporarily
  if (status == 204 || status == 301 || status == 302) {
    return(res)
  }
  if (status == 404) # Not found
    return(NULL)

  if (status >= 200 && status < 400)  { # no error
    # check content-type
    content_type <- res$headers$`Content-Type`
    if (!.is_nz_string(content_type) || content_type != JSON) return(res)
    return(TRUE)
  }

  .die_if(status == 429, 
    "API error: Too many requests, please retry in %i seconds", res$header$"retry-after")

  .die_if(status == 401, 
    "Unauthorized: %s (error %s)", get_api_response_error_message(res), status)

  .die_if(status == 400, "API error: %s", get_api_response_error_message(res))

  .die("Uknown API error %s: %s", status,  get_api_response_error_message(res))
}


# Private API request method.
request_edp_api <- function(method, path = '', query = list(), body = list(),
                            conn = get_connection(),
                            content_type = "application/json",
                            uri = file.path(conn$host, path),
                            # raw = TRUE,
                            params = list(),
                            limit = NULL, 
                            page = NULL,
                            offset = NULL,
                            postprocess = TRUE,
                            as = NULL,
                            encoding = "UTF-8",
                            simplifyDataFrame = FALSE,
                            verbose = getOption('quartzbio.edp.verbose', TRUE),
                            ...)
{
  check_connection(conn)

  ### params
  if (length(limit)) params$limit <- limit
  if (length(page)) params$page <- page
  if (length(offset)) {
    if (offset < 0) return(NULL)
    params$offset <- offset
  }

  if (length(params)) {
    if (method == 'GET') {
      query <- modifyList(query, params)
    } else {
      body <- modifyList(body, params)
    }
  }

  ### headers
  headers <- c(
    "Accept" = JSON,
    "Accept-Encoding" = "gzip,deflate",
    "Content-Type" = content_type,
    c(format_auth_header(conn$secret))
  )

  ### URI
  if (substring(path, 1, 1) == "/") {
    path <- substring(path, 2)
  }
  force(uri)
  if (verbose) {
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
  if (content_type == JSON) {
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
    encode = encode,
    ...
  )

  # N.B: may die with an appropriate error message
  ret <- check_httr_response(res)
  if (!isTRUE(ret)) return(ret)

  content <- httr::content(res, as = as, encoding = encoding, simplifyDataFrame = simplifyDataFrame)

  if (postprocess) {
    content <- postprocess_response(content)
    if (inherits(content, 'edpdf')) {
      if (!length(offset)) offset <- 0L
      .fun <- function(limit, offset) request_edp_api(method = method, path = path, query = query, 
        uri = uri, params = params, limit = limit, page = page, offset = offset, postprocess = postprocess, as = as,
        encoding = encoding, simplifyDataFrame = simplifyDataFrame, verbose = verbose, ...)

      content <- setup_prev_next(content, .fun, limit, offset)
    }
  }

  conn <- as.environment(conn)
  attr(content, 'connection') <- conn
  if (inherits(content, 'edplist'))
    for (i in seq_along(content) )
      attr(content[[i]], 'connection') <- conn

  content
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

# add a class to an EDP entity, using it $class_name item
classify_entity <- function(x) {
  if (!is.list(x)) return(x)

  class_name <- x$class_name
  if (!.is_nz_string(class_name)) return(x)

  if (class_name != 'list') {
    # special case for objects
    if (class_name == 'Object') {
      class(x) <- c(capitalize(x$object_type), 'Object', class(x))
    } else {
      class(x) <- c(class_name, class(x))
    }
  }

  x
}

# process a response that contains only a single entity: classify it, and classify its ids
postprocess_single_entity <- function(res) {
  res <- classify_entity(res)
  res <- classify_ids(res)

  res
}

# return a edplist
postprocess_entity_list <- function(res, key) {
  lst <- res[[key]]

  lst <- lapply(lst, classify_entity)
    # decorate objects
  lst <- lapply(lst, classify_ids)

    # check what kind of objects are in the list
  lst <- edplist(lst)
  if (length(lst)) {
    # class_obj <- class(lst[[1]])[1]
    class_obj <- lst[[1]]$class_name
    if (.is_nz_string(class_obj))
      class(lst) <- c(paste0(class_obj, 'List'), class(lst))
  }

  # store other items as attributes on the edp list
  items <- setdiff(names(res), c(key, 'class', 'class_name'))
  for (attr in items) 
    attr(lst, attr) <- res[[attr]]

  lst
}

postprocess_df <- function(res, key) {
  df <- edpdf(res[[key]])

  # store other items as attributes
  items <- setdiff(names(res), c(key, 'class', 'class_name'))
  for (attr in items) 
    attr(df, attr) <- res[[attr]]

  df
}

# 3 main cases:
# - result for one object/entity
# - results for a list of objects/entitities
# - results for some data as a dataframe
postprocess_response <- function(res) {
  # dispatch
  class_name <- res$class_name
  if (!.is_nz_string(class_name)) class_name <- ''

  if (!'total' %in% names(res) && class_name != 'list') {
    # consider it is a single entity
    return(postprocess_single_entity(res))
  }

  ### results are either in $data or $results
  key <- intersect(names(res), c('data', 'results'))
  .die_if(length(key) == 0, 'got NEITHER data NOR results in response')
  .die_if(length(key) > 1, 'got BOTH data AND results in response')

  value <- res[[key]]
  # BEWARE: a data.frame IS a list
  if (is.data.frame(value)) return(postprocess_df(res, key))
  if (is.list(value)) return(postprocess_entity_list(res, key))

  .die('unknow response data type: class=%s, type=%s', class(value), typeof(value)) 
}

classify_ids <- function(x) {
  # look for ids
  id_names <- grep('_id$', names(x), value = TRUE)
  for (name in id_names) {
    if (length(x[[name]])) {
      class_name <- head(tail(strsplit(name, '_')[[1]], 2), 1)
      class_name  <- paste0(toupper(substring(class_name, 1, 1)), substring(class_name, 2))
      class_name <- paste0(class_name, 'Id')
      class(x[[name]]) <- c(class_name, class(x[[name]]))

      x
    }
  }

  x
}


setup_prev_next <- function(x, fun, limit, offset) {
  if (!length(x)) return(x)
  # fun2 <- function(limit, page) setup_prev_next(fun(limit, page), fun, limit, page)

  attr(x, 'next') <- function() { fun(limit, offset + limit)}
  attr(x, 'prev') <- function() { fun(limit, offset - limit) }

  x
}
