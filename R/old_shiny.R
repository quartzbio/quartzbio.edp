# nocov start

#' New function for EDP auth of shiny app. Returns the
#' updated session with EDP connection to be used in shiny app
#' @param input input
#' @param session session
#' @param client_id client_id
#' @param client_secret secret
#' @param base_url BASE URL
#' @param create_logfile (logical) Create a file to log records. Default is set to FALSE. Log file name will be generated automatically.
#' @export
quartzbio_shiny_auth <- function(input, session, client_id, client_secret = NULL, base_url, create_logfile = FALSE) {
  .check_for_valid_conn <- function(session) {
    auth_env <- session$userData$solvebio_env
    tryCatch(
      {
        user <- User.retrieve(env = auth_env)
        log_message("INFO", paste("Connected to Quartzbio EDP with user", user$full_name))
      },
      error = function(e) {
        log_message("ERROR", paste("Connection to Quartzbio EDP Failed:", e$message))
      }
    )
  }

  .initializeSession <- function(session, token, token_type = "Bearer") {
    if (is.null(token)) {
      env <- NULL
      user <- NULL
    } else {
      env <- connect(secret = token)
      user <- User.retrieve(env = env)
    }

    session$userData$solvebio_env <- env
    session$userData$solvebio_user <- user

    session
  }

  # OAuth2 helper functions
  .makeRedirectURI <- function(session) {
    port <- session$clientData$url_port
    url <- paste0(
      session$clientData$url_protocol,
      "//",
      session$clientData$url_hostname,
      if (port != "") paste0(":", port),
      session$clientData$url_pathname
    )
  }

  .makeAuthorizationURL <- function(session) {
    url <- "%s/authorize?client_id=%s&redirect_uri=%s&response_type=code"
    sprintf(
      url,
      base_url,
      utils::URLencode(client_id, reserved = TRUE, repeated = TRUE),
      utils::URLencode(.makeRedirectURI(session), reserved = TRUE, repeated = TRUE)
    )
  }

  .showLoginModal <- function(session) {
    onclick <- sprintf("window.location = '%s'", .makeAuthorizationURL(session))
    modal <- shiny::modalDialog(
      shiny::tags$span("Please log in with QuartzBio EDP before proceeding."),
      footer = shiny::tagList(
        shiny::actionButton(
          inputId = "login-button",
          label = "Log in with QuartzBio EDP",
          onclick = onclick
        )
      ),
      easyClose = FALSE
    )
    shiny::showModal(modal)
  }

  # By default cookie auth is disabled, set up dummy functions.
  # They will be overwritten below if encryption is enabled.
  .encryptToken <- function(token) {
    token
  }

  .decryptToken <- function(token) {
    token
  }

  # Return a authenticated Shiny session function
  auth_session <- function(input, session) {
    enable_cookie_auth <- tryCatch(
      {
        if (requireNamespace("shinyjs", quietly = TRUE)) {
          # This will fail if getCookie is not declared in JS
          shinyjs::js$enableCookieAuth()
          TRUE
        } else {
          log_message("WARN", "This app requires shinyjs to use cookies for token storage.")
          FALSE
        }
      },
      error = function(e) {
        # Cookie JS is not enabled, disable cookies
        log_message("WARN", "This app has not been configured to use cookies for token storage.")
        FALSE
      }
    )
    params <- gsub(pattern = "?", replacement = "", x = session$clientData$url_search)
    parsed_params <- shiny::parseQueryString(params)
    if (!is.null(parsed_params$code)) {
      # Remove the code from the query params after parsing
      # NOTE: Setting updateQueryString to an empty string or relative path
      #       causes browsers to prepend the "base href" string
      #       which contains a session identifier on Shiny Server Pro.
      redirect_uri <- .makeRedirectURI(session)
      shiny::updateQueryString(redirect_uri, mode = "replace")

      # Retrieve an access_token from the code
      oauth_params <- list(
        client_id = client_id,
        client_secret = client_secret,
        grant_type = "authorization_code",
        redirect_uri = redirect_uri,
        code = parsed_params$code
      )
      log_message("INFO", "Proceeding to reterieve QuartzBio EDP OAuth2 token")

      oauth_data <- tryCatch(
        {
          .request("POST",
            path = "v1/oauth2/token",
            query = NULL,
            body = oauth_params,
            env = connect(secret = "", check = FALSE),
            content_type = "application/x-www-form-urlencoded"
          )
        },
        error = function(e) {
          log_message("ERROR", sprintf("ERROR: Unable to retrieve QuartzBio EDP OAuth2 token. Check your client_id and client_secret (if used). Error: %s\n", e))
        }
      )

      if (enable_cookie_auth) {
        # # Setting the cookie and retrieve the user
        shinyjs::js$setCookie(.encryptToken(oauth_data$access_token))
        .initializeSession(session, token = oauth_data$access_token)
        .check_for_valid_conn(session)
        return()
      } else {
        # Set the token and retrieve the user
        .initializeSession(session, token = oauth_data$access_token)
        .check_for_valid_conn(session)
        return()
      }
    }

    # Logging
    if (create_logfile) {
      log_file <- paste("quartzbio_shiny_", format(Sys.time(), "%Y-%m-%d_%H%M%S"), ".log", sep = "")
      log_file <- configure_logger(log_file)
    }


    if (enable_cookie_auth) {
      # Setup token encryption using the secret key
      if (!is.null(client_secret) && client_secret != "") {
        requireNamespace("openssl")

        # MD5 maps client-secret to unique 32bit raw key
        aes_key <- openssl::md5(charToRaw(client_secret))

        .encryptToken <- function(token) {
          # Use iv = NULL to support restarts of the Shiny server
          # without deactivating existing encrypted keys.
          encrypted_raw <- openssl::aes_cbc_encrypt(charToRaw(token), key = aes_key, iv = NULL)
          openssl::base64_encode(encrypted_raw)
        }

        .decryptToken <- function(encrypted_token) {
          raw <- openssl::base64_decode(encrypted_token)
          rawToChar(openssl::aes_cbc_decrypt(raw, key = aes_key))
        }
      } else {
        log_message("WARN", "QuartzBio EDP OAuth2 tokens will not be encrypted in cookies. Set client_secret to encrypt tokens.")
      }

      shiny::observe({
        try(shinyjs::js$getCookie(), silent = FALSE)

        # Only proceed if the token cookie is set
        shiny::req(input$tokenCookie)

        # Handle the case where an auth cookie is found
        tryCatch(
          {
            # Setup and test the auth token
            .initializeSession(session, token = .decryptToken(input$tokenCookie))
            # Close the auth modal which will be opened by the code below
            shiny::removeModal()
            .check_for_valid_conn(session)
            return()
          },
          error = function(e) {
            # Cookie has an invalid/expired token.
            # Clear the cookie and show the auth modal.
            try(shinyjs::js$rmCookie())
            session$reload()
          }
        )
      })

      shiny::observeEvent(input$logout, {
        try(shinyjs::js$rmCookie())
        session$reload()
      })
    } else {
      # warning("WARNING: QuartzBio EDP cookie-based token storage is disabled.")
      log_message("INFO", "QuartzBio EDP cookie-based token storage is disabled.")
    }

    shiny::observeEvent(session$clientData$url_search,
      {
        # params <- gsub(pattern = "?", replacement = "", x = session$clientData$url_search)
        # parsed_params <- shiny::parseQueryString(params)
        # If the global env is set (via environment variables), use that.
        # This can be used for local development or automated tests to bypass
        # the login modal.
        if (.config$token != "") {
          log_message("WARN", "Found credentials in global environment, will not show login modal.")
          .initializeSession(session,
            token = .config$token,
            token_type = .config$token_type
          )
          .check_for_valid_conn(session)
          return()
        } else {
          # Clear the session and show the modal
          .initializeSession(session, token = NULL)
          .showLoginModal(session)
        }
      },
      once = TRUE
    )
  }

  auth_session(input, session)
}


#' protectedServer
#'
#' Wraps an existing Shiny server in an OAuth2 flow.
#'
#' @param server Your original Shiny server function.
#' @param client_id Your application's client ID.
#' @param client_secret (optional) Your application's client secret.
#' @param base_url (optional) Override the default login host (default: https://my.solvebio.com).
#'
#' @examples \dontrun{
#' protectedServer(
#'   server = server,
#'   client_id = "abcd1234"
#' )
#' }
#'
#' @concept  quartzbio_api
#' @export
protectedServer <- function(server, client_id, client_secret = NULL, base_url = "https://my.solvebio.com") {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Shiny is required to use quartzbio.edp::protectedServer()")
  }

  # Initialize the server session using a QuartzBio EDP token.
  # Sets up the QuartzBio EDP env and current user.
  .initializeSession <- function(session, token, token_type = "Bearer") {
    if (is.null(token)) {
      env <- NULL
      user <- NULL
    } else {
      env <- connect(secret = token)
      user <- User.retrieve(env = env)
    }

    session$userData$solvebio_env <- env
    session$userData$solvebio_user <- user

    session
  }

  # OAuth2 helper functions
  .makeRedirectURI <- function(session) {
    port <- session$clientData$url_port
    url <- paste0(
      session$clientData$url_protocol,
      "//",
      session$clientData$url_hostname,
      if (port != "") paste0(":", port),
      session$clientData$url_pathname
    )
  }

  .makeAuthorizationURL <- function(session) {
    url <- "%s/authorize?client_id=%s&redirect_uri=%s&response_type=code"
    sprintf(
      url,
      base_url,
      utils::URLencode(client_id, reserved = TRUE, repeated = TRUE),
      utils::URLencode(.makeRedirectURI(session), reserved = TRUE, repeated = TRUE)
    )
  }

  .showLoginModal <- function(session) {
    onclick <- sprintf("window.location = '%s'", .makeAuthorizationURL(session))
    modal <- shiny::modalDialog(
      shiny::tags$span("Please log in with QuartzBio EDP before proceeding."),
      footer = shiny::tagList(
        shiny::actionButton(
          inputId = "login-button",
          label = "Log in with QuartzBio EDP",
          onclick = onclick
        )
      ),
      easyClose = FALSE
    )
    shiny::showModal(modal)
  }

  # By default cookie auth is disabled, set up dummy functions.
  # They will be overwritten below if encryption is enabled.
  .encryptToken <- function(token) {
    token
  }

  .decryptToken <- function(token) {
    token
  }

  # Return a wrapped Shiny server function
  function(input, output, session, ...) {
    enable_cookie_auth <- tryCatch(
      {
        if (requireNamespace("shinyjs", quietly = TRUE)) {
          # This will fail if getCookie is not declared in JS
          shinyjs::js$enableCookieAuth()
          TRUE
        } else {
          warning("WARNING: This app requires shinyjs to use cookies for token storage.")
          FALSE
        }
      },
      error = function(e) {
        # Cookie JS is not enabled, disable cookies
        warning("WARNING: This app has not been configured to use cookies for token storage.")
        FALSE
      }
    )

    if (enable_cookie_auth) {
      # Setup token encryption using the secret key
      if (!is.null(client_secret) && client_secret != "") {
        requireNamespace("openssl")

        # MD5 maps client-secret to unique 32bit raw key
        aes_key <- openssl::md5(charToRaw(client_secret))

        .encryptToken <- function(token) {
          # Use iv = NULL to support restarts of the Shiny server
          # without deactivating existing encrypted keys.
          encrypted_raw <- openssl::aes_cbc_encrypt(charToRaw(token), key = aes_key, iv = NULL)
          openssl::base64_encode(encrypted_raw)
        }

        .decryptToken <- function(encrypted_token) {
          raw <- openssl::base64_decode(encrypted_token)
          rawToChar(openssl::aes_cbc_decrypt(raw, key = aes_key))
        }
      } else {
        warning("WARNING: QuartzBio EDP OAuth2 tokens will not be encrypted in cookies. Set client_secret to encrypt tokens.")
      }

      shiny::observe({
        try(shinyjs::js$getCookie(), silent = FALSE)

        # Only proceed if the token cookie is set
        shiny::req(input$tokenCookie)

        # Handle the case where an auth cookie is found
        tryCatch(
          {
            # Setup and test the auth token
            .initializeSession(session, token = .decryptToken(input$tokenCookie))
            # Close the auth modal which will be opened by the code below
            shiny::removeModal()
          },
          error = function(e) {
            # Cookie has an invalid/expired token.
            # Clear the cookie and show the auth modal.
            try(shinyjs::js$rmCookie())
            session$reload()
          }
        )

        # Run the wrapped server
        server(input, output, session, ...)
      })

      shiny::observeEvent(input$logout, {
        try(shinyjs::js$rmCookie())
        session$reload()
      })
    } else {
      warning("WARNING: QuartzBio EDP cookie-based token storage is disabled.")
    }

    shiny::observeEvent(session$clientData$url_search,
      {
        params <- gsub(pattern = "?", replacement = "", x = session$clientData$url_search)
        parsed_params <- shiny::parseQueryString(params)

        if (!is.null(parsed_params$code)) {
          # Remove the code from the query params after parsing
          # NOTE: Setting updateQueryString to an empty string or relative path
          #       causes browsers to prepend the "base href" string
          #       which contains a session identifier on Shiny Server Pro.
          redirect_uri <- .makeRedirectURI(session)
          shiny::updateQueryString(redirect_uri, mode = "replace")
          # Retrieve an access_token from the code
          oauth_params <- list(
            client_id = client_id,
            client_secret = client_secret,
            grant_type = "authorization_code",
            redirect_uri = redirect_uri,
            code = parsed_params$code
          )
          oauth_data <- tryCatch(
            {
              .request("POST",
                path = "v1/oauth2/token",
                query = NULL,
                body = oauth_params,
                env = connect(secret = "", check = FALSE),
                content_type = "application/x-www-form-urlencoded"
              )
            },
            error = function(e) {
              stop(sprintf("ERROR: Unable to retrieve QuartzBio EDP OAuth2 token. Check your client_id and client_secret (if used). Error: %s\n", e))
            }
          )

          # Set an auth cookie using a JS cookie library
          if (enable_cookie_auth) {
            # Setting the cookie will run the server above
            shinyjs::js$setCookie(.encryptToken(oauth_data$access_token))
          } else {
            # Set the token and retrieve the user
            .initializeSession(session, token = oauth_data$access_token)
            # Run the wrapped server
            server(input, output, session, ...)
          }
        } else {
          # If the global env is set (via environment variables), use that.
          # This can be used for local development or automated tests to bypass
          # the login modal.
          if (.config$token != "") {
            warning("WARNING: Found credentials in global environment, will not show login modal.")
            .initializeSession(session,
              token = .config$token,
              token_type = .config$token_type
            )
            # Run the wrapped server
            server(input, output, session, ...)
          } else {
            # Clear the session and show the modal
            .initializeSession(session, token = NULL)
            .showLoginModal(session)
          }
        }
      },
      once = TRUE
    )
  }
}


#' protectedServerUI
#'
#' Returns ShinyJS-compatible JS code to support cookie-based token storage.
#'
#' @examples \dontrun{
#' jscookie_src <- "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.0/js.cookie.js"
#' ui <- fluidPage(
#'   shiny::tags$head(
#'     shiny::tags$script(src = jscookie_src)
#'   ),
#'   useShinyjs(),
#'   extendShinyjs(
#'     text = quartzbio.edp::protectedServerJS(),
#'     functions = c("enableCookieAuth", "getCookie", "setCookie", "rmCookie")
#'   )
#' )
#' }
#'
#' @concept  quartzbio_api
#' @export
protectedServerJS <- function() {
  if (!requireNamespace("shinyjs", quietly = TRUE)) {
    stop("ShinyJS is required to use quartzbio.edp::protectedServerJS()")
  }

  '
    shinyjs.enableCookieAuth = function(params) {
        return true;
    }

    shinyjs.getCookie = function(params) {
        Shiny.onInputChange("tokenCookie", Cookies.get("sb_auth") || "");
    }

    shinyjs.setCookie = function(params) {
        if (Array.isArray(params)) {
            params = params[0];
        }
        Cookies.set("sb_auth", params, { expires: 0.5 });
    }

    shinyjs.rmCookie = function(params) {
        Cookies.remove("sb_auth");
    }
    '
}
# nocov end
