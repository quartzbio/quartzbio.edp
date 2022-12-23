# Internal functions and environments used internally
# by the QuartzBio EDP package (not exported).

# Store the QuartzBio EDP config in an environment
# The default environment uses an API key (token type: "Token").



.config <- new.env()
# .config$host <- EDP_DEFAULT_API_HOST
.config$token <- Sys.getenv('SOLVEBIO_API_KEY', unset='')
.config$token_type <- 'Token'

# if (nchar(.config$token) == 0L) {
#     # No API key, look for access token
#     .config$token <- Sys.getenv('SOLVEBIO_ACCESS_TOKEN', unset='')
#     if (nchar(.config$token) > 0L) {
#         .config$token_type <- 'Bearer'
#     }
# }


#' login
#'
#' Store and verify your QuartzBio EDP credentials.
#'
#' @param api_key Your QuartzBio EDP API key
#' @param api_host QuartzBio EDP API host (default: https://api.solvebio.com)
#' @param env (optional) The R environment used to store API credentials.
#'
#' @examples \dontrun{
#' login()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @export
login <- function(
    api_key = Sys.getenv('SOLVEBIO_API_KEY'), 
    api_token = Sys.getenv('SOLVEBIO_ACCESS_TOKEN'),
    api_host = Sys.getenv('SOLVEBIO_API_HOST'), 
    env = get_connection()) 
  {
    .is_nzs <- function(x) { length(x) == 1 && !is.na(x) && is.character(x) && nzchar(x)  }
    token <- NULL
    token_type <- NULL
    if (.is_nzs(api_key)) {
      token <- api_key
      token_type <- 'Token'
    }
      
    if (.is_nzs( api_token)) {
      token <- api_token
      token_type <- 'Bearer'
    }

    if (!.is_nzs(token)) {
      stop("No Access Token or API key found. Learn more: https://docs.solvebio.com/#authenticating-with-r")
    }

    assign('token', token, envir = env)
    assign('token_type', token_type, envir = env)
    assign('host', api_host, envir = env)



    # if(nchar(env$token) == 0L) {
    #     # No API key, look for access token
    #     .config$token <- Sys.getenv('SOLVEBIO_ACCESS_TOKEN', unset='')
    #     if (nchar(.config$token) > 0L) {
    #         .config$token_type <- 'Bearer'
    #     }
    #     else {
    #         stop("No Access Token or API key found. Learn more: https://docs.solvebio.com/#authenticating-with-r")
    #     }
    # }
    # if (!missing(api_host)) {
    #     assign('host', api_host, envir=env)
    # }

    # Test the login
    tryCatch({
        user <- User.retrieve(env = env)
        cat(sprintf("Logged-in to %s as %s.\n", env$host, user$email))
        return(invisible(user))
    }, error = function(e) {
        cat(sprintf("Login failed: %s\n", e$message))
    })
}



# createEnv <- function(token, token_type="Token", host = Sys.getenv('SOLVEBIO_API_HOST', EDP_DEFAULT_API_HOST)) {
#     newEnv <- new.env()
#     newEnv$token <- token
#     newEnv$token_type <- token_type
#     newEnv$host <- host
#     return(newEnv)
# }


# Private API request method.
.request = function(method, path, query, body, 
  env = get_connection(), 
  content_type="application/json", 
  raw = TRUE,
  ...) 
{
  # check connection, and initialize it if needed
  check_connection(env)

  'Perform an HTTP request to the server.'
  # Set defaults
  headers <- c(
                "Accept" = "application/json",
                "Accept-Encoding" = "gzip,deflate",
                "Content-Type" = content_type
                )

  if (.is_nz_string(env$secret)) {
    headers <- c(headers, format_auth_header(env$secret))
  }

  # Slice of beginning slash
  if (substring(path, 1, 1) == "/") {
      path <- substring(path, 2)
  }
  
  uri <- httr::modify_url(env$host, "path" = path)
  useragent <- sprintf('QuartzBio EDP R Client %s [%s %s]',
                        packageVersion('quartzbio.edp'),
                        R.version$version.string,
                        R.version$platform)
  config <- httr::config(useragent = useragent)
  encode = "form"

  if (content_type == "application/json") {
      if (!missing(body) && !is.null(body) && length(body) > 0) {
          body <- jsonlite::toJSON(body, auto_unbox=TRUE, null="null")
          encode = "json"
      }
  }

  if (missing(query)) {
      query = NULL
  }

  switch(method, 
          GET={
              res <- httr::GET(
                              uri,
                              httr::add_headers(headers),
                              config = config,
                              query = query,
                              # httr::verbose(),
                              ...
                              )
          },
          POST={
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
          PUT={
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
          PATCH={
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
          DELETE={
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
              stop('Invalid request method!')
          }
          )


  if (res$status < 200 | res$status >= 400) {
      if (res$status == 429) {
          stop(sprintf("API error: Too many requests, please retry in %i seconds\n", res$header$'retry-after')) 
      }
      if (res$status == 400) {
          tryCatch({
              content = formatEDPResponse(res, raw = FALSE)
              if (!is.null(content$detail)) {
                  stop(sprintf("API error: %s\n", content$detail))
              } else {
                  stop(sprintf("API error: %s\n", content))
              }
          }, error = function(e) {
              cat(sprintf("Error parsing API response\n"))
              stop(res)
          })
      }
      if (res$status == 401) {
          stop(sprintf("Unauthorized: %s (error %s)\n", httr::content(res, as="parsed")$detail, res$status))
      }

      content = httr::content(res, as="text", encoding="UTF-8")
      stop(sprintf("API error %s %s\n", res$status, content))
  }

  if (res$status == 204 | res$status == 301 | res$status == 302) {
      return(res)
  }

  res = formatEDPResponse(res, raw = FALSE)

  if (!is.null(res$class_name)) {
      # Classify the result object
      res <- structure(res, class=res$class_name)
  }

  if (!raw) res <- res$results

  res
}
