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


# Error Code 	Meaning 	Description
# 400 	Bad Request 	Your request was malformed
# 401 	Unauthorized 	Your API key or token is invalid
# 403 	Forbidden 	Your API key or token is not valid for this type of request
# 404 	Not Found 	The specified resource could not be found
# 405 	Method Not Allowed 	Your request used an invalid method
# 429 	Too Many Requests 	You have reached the rate limit
# 500 	Internal Server Error 	We had a problem with our server
# 503 	Service Unavailable 	We are temporarily offline for maintenance
check_httr_response_error <- function(res) {
  status <- res$status

  if (status >= 200 && status < 400) # no error
    return()

  .die_if(status == 429, 
    "API error: Too many requests, please retry in %i seconds", res$header$"retry-after")

  .die_if(status == 401, 
    "Unauthorized: %s (error %s)", get_api_response_error_message(res), status)

  .die_if(status == 400, "API error: %s", get_api_response_error_message(res))

  .die("Uknown API error %s: %s", status,  get_api_response_error_message(res))
}


# Private API request method.
request_edp_api <- function(method, path, query = list(), body = list(),
                            conn,
                            content_type = "application/json",
                            # raw = TRUE,
                            params = list(),
                            limit = NULL, 
                            page = NULL,
                            postprocess = TRUE,
                            as = NULL,
                            encoding = "UTF-8",
                            simplifyDataFrame = FALSE,
                            verbose = TRUE,
                            ...) 
{
  if (verbose) {
    msg <- sprintf('%s %s...', method, path)
    message(msg)
  }
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
  uri <- file.path(conn$host, path)

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

  status <- res$status
  # 204: no content, 301: moved permanently, 302: Moved Temporarily
  if (status == 204 || status == 301 || status == 302) {
    return(res)
  }
  if (status == 404) # Not found
    return(NULL)

  check_httr_response_error(res)

  content <- httr::content(res, as = as, encoding = encoding, simplifyDataFrame = simplifyDataFrame)
  # if (raw) return(content)

  # if (!.is_nz_string(content$class_name)) {
  #   class(content) <- content$class_name
  # }
  if (postprocess) {
    content <- postprocess_response(content)
  }

  attr(content, 'connection') <- as.environment(conn)

  content
}

# set types (class)
postprocess_response <- function(res) {
    .classify <- function(x) {
      class_name <- x$class_name
      if (.is_nz_string(class_name) && class_name != 'list')
        class(x) <- c(class_name, class(x))
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

   # store other items as attributes
  items <- setdiff(names(res), c(key))
  for (attr in items) 
    attr(data, attr) <- res[[attr]]

  if (is.data.frame(data)) {
    # nothing cyrrently to do
    class(data) <- c('edpdf', 'data.frame')
  } else {
    data <- lapply(data, .classify)
      # decorate objects
    data <- lapply(data, decorate)

      # check what kind of objects are in the list
    class(data) <- c('edplist', 'list')
    if (length(data)) {
      class_obj <- class(data[[1]])[1]
      if (.is_nz_string(class_obj))
        class(data) <- c(paste0(class_obj, 'List'), class(data))
    }
  }

  data
}

convert_edp_list_data_to_df <- function(lst) {
  df <- as.data.frame(do.call(rbind,  lst), stringsAsFactors = FALSE)

  if (length(lst)) {
    # N.B: use the first row to infer types
    row1 <- lst[[1]]

    for (col in seq_along(df)) {
      # only if all scalars
      if (all(lengths(df[[col]]) == 1)) 
        df[[col]] <- as(df[[col]], typeof(row1[[col]]))
    }
  }

  df
}
