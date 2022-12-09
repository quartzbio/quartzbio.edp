format_auth_header <- function(conn) {
  token_type <- if (conn$is_key) 'Token' else 'Bearer'
  c(Authorization = paste(token_type, conn$secret, sep = " "))
}

# Private API request method.
request_edp_api <- function(method, path, query, body,
                            conn,
                            content_type = "application/json",
                            raw = TRUE,
                            ...) {
  # Set defaults
  headers <- c(
    "Accept" = "application/json",
    "Accept-Encoding" = "gzip,deflate",
    "Content-Type" = content_type
  )

  if (!is.null(env$token) && nchar(env$token) != 0) {
    headers <- c(
      headers,
      Authorization = paste(env$token_type, env$token, sep = " ")
    )
  }

  # Slice of beginning slash
  if (substring(path, 1, 1) == "/") {
    path <- substring(path, 2)
  }

  uri <- httr::modify_url(env$host, "path" = path)
  useragent <- sprintf(
    "QuartzBio EDP R Client %s [%s %s]",
    packageVersion("quartzbio.edp"),
    R.version$version.string,
    R.version$platform
  )
  config <- httr::config(useragent = useragent)
  encode <- "form"

  if (content_type == "application/json") {
    if (!missing(body) && !is.null(body) && length(body) > 0) {
      body <- jsonlite::toJSON(body, auto_unbox = TRUE, null = "null")
      encode <- "json"
    }
  }

  if (missing(query)) {
    query <- NULL
  }

  switch(method,
    GET = {
      res <- httr::GET(
        uri,
        httr::add_headers(headers),
        config = config,
        query = query,
        # httr::verbose(),
        ...
      )
    },
    POST = {
      res <- httr::POST(
        uri,
        httr::add_headers(headers),
        config = config,
        body = body,
        query = query,
        encode = encode,
        # httr::verbose(),
        ...
      )
    },
    PUT = {
      res <- httr::PUT(
        uri,
        httr::add_headers(headers),
        config = config,
        body = body,
        query = query,
        encode = encode,
        # httr::verbose(),
        ...
      )
    },
    PATCH = {
      res <- httr::PATCH(
        uri,
        httr::add_headers(headers),
        config = config,
        body = body,
        query = query,
        encode = encode,
        # httr::verbose(),
        ...
      )
    },
    DELETE = {
      res <- httr::DELETE(
        uri,
        httr::add_headers(headers),
        config = config,
        query = query,
        # httr::verbose(),
        ...
      )
    },
    {
      stop("Invalid request method!")
    }
  )


  if (res$status < 200 | res$status >= 400) {
    if (res$status == 429) {
      stop(sprintf("API error: Too many requests, please retry in %i seconds\n", res$header$"retry-after"))
    }
    if (res$status == 400) {
      tryCatch(
        {
          content <- formatEDPResponse(res, raw = FALSE)
          if (!is.null(content$detail)) {
            stop(sprintf("API error: %s\n", content$detail))
          } else {
            stop(sprintf("API error: %s\n", content))
          }
        },
        error = function(e) {
          cat(sprintf("Error parsing API response\n"))
          stop(res)
        }
      )
    }
    if (res$status == 401) {
      stop(sprintf("Unauthorized: %s (error %s)\n", httr::content(res, as = "parsed")$detail, res$status))
    }

    content <- httr::content(res, as = "text", encoding = "UTF-8")
    stop(sprintf("API error %s %s\n", res$status, content))
  }

  if (res$status == 204 | res$status == 301 | res$status == 302) {
    return(res)
  }

  res <- formatEDPResponse(res, raw = FALSE)

  if (!is.null(res$class_name)) {
    # Classify the result object
    res <- structure(res, class = res$class_name)
  }

  if (!raw) res <- res$results

  res
}