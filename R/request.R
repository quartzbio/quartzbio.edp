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
    capacity = c('small', 'medium', 'large'),
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

  if (status >= 200 && status < 400) # no error
    return(TRUE)

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
                            postprocess = TRUE,
                            as = NULL,
                            encoding = "UTF-8",
                            simplifyDataFrame = FALSE,
                            verbose = getOption('quartzbio.edp.verbose', TRUE),
                            ...) 
{
  check_connection(conn)
  JSON <- "application/json"

  ### params
  if (length(limit)) params$limit <- limit
  if (length(page)) params$page <- page

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
  # if (raw) return(content)

  # if (!.is_nz_string(content$class_name)) {
  #   class(content) <- content$class_name
  # }
  if (postprocess) {
    content <- postprocess_response(content)
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
      nb_set <- sum(lengths(x) == 1)
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

# set types (class)
postprocess_response <- function(res) {
  .classify <- function(x) {
    class_name <- x$class_name
    if (.is_nz_string(class_name) && class_name != 'list') {

      # special case for objects
      if (class_name == 'Object') {
        class(x) <- c(capitalize(x$object_type), 'Object', class(x))
      } else {
        class(x) <- c(class_name, class(x))
      }
    }
    x
  }

  # is the content an object or a list of objects...
  # a list of objects should have the $total key and have a class_name=='list'
  if (!'total' %in% names(res) && res$class_name != 'list') {
    # consider it is an object
    res <- .classify(res)
    res <- decorate(res)
    return(res)
  }

  ### results are either in $data or $results
  key <- NULL
  if ('data' %in% names(res) && length(res$data)) {
    key <- 'data' 
  } else if ('results' %in% names(res) && length(res$results)) {
    key <- 'results' 
  }

  # no data
  data <- list()
  if (length(key)) {
    data <- res[[key]]
  }


  ### should never be a data frame
  # if (is.data.frame(data)) {
  #   # nothing cyrrently to do
  #   class(data) <- c('edpdf', 'data.frame')
  # } else {
    data <- lapply(data, .classify)
      # decorate objects
    data <- lapply(data, decorate)

      # check what kind of objects are in the list
    class(data) <- c('edplist', 'list')
    if (length(data)) {
      # class_obj <- class(data[[1]])[1]
      class_obj <- data[[1]]$class_name
      if (.is_nz_string(class_obj))
        class(data) <- c(paste0(class_obj, 'List'), class(data))
    }
  # }

  # store other items as attributes
  items <- setdiff(names(res), c(key, 'class', 'class_name'))
  for (attr in items) 
    attr(data, attr) <- res[[attr]]

  data
}

decorate <- function(x) {
  # look for ids
  id_names <- grep('_id$', names(x), value = TRUE)
  for (name in id_names) {
    if (length(x[[name]])) {
      class_name <- head(tail(strsplit(name, '_')[[1]], 2), 1)
      class_name  <- paste0(toupper(substring(class_name, 1, 1)), substring(class_name, 2))
      class_name <- paste0(class_name, 'Id')
      class(x[[name]]) <- class_name

      x
    }
  }

  x
}


