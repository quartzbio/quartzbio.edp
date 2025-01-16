
# Sys.getenv does not return unser if the variable is set but empty
get_env <- function(name, unset = "") {
  vx <- Sys.getenv(name)
  if (.is_nz_string(vx)) vx else unset
}

looks_like_api_key <- function(x) {
  .is_nz_string(x) && nchar(x) == 40
}

looks_like_api_token <- function(x) {
  .is_nz_string(x) && nchar(x) == 30
}

check_connection <- function(conn) {
  .die_unless(length(conn) >= 1, "bad connection")
  ns <- names(conn)
  .die_unless("secret" %in% ns, 'no "secret" in connection')
  .die_unless("host" %in% ns, 'no "host" in connection')

  secret <- conn$secret
  .die_unless(.is_nz_string(conn$host), 'bad "host" in connection')

  # secret as empty string used by shiny wrapper when requesting a token
  if (secret == "") {
    return()
  }
  .die_unless(.is_nz_string(secret), 'no "secret" in connection')


  .die_unless(
    looks_like_api_key(secret) || looks_like_api_token(secret),
    "connection secret does not look like an API key nor token"
  )
}


#' test a connection
#'
#' may die on bad connection
#' @inheritParams params
#' @return TRUE iff the connection was successful
#' @export
test_connection <- function(conn) {
  check_connection(conn)

  # N.B: not silent on purpose
  res <- try(request_edp_api("GET", "v1/user", conn = conn), silent = TRUE)

  if (.is_error(res)) {
    warning(paste("got error connecting:", .get_error_msg(res)))
    stop(.get_error(res))
  }

  .die_unless(inherits(res, "User"), "could not retrieve user profile.")

  type <- if (looks_like_api_key(conn$secret)) "Key" else "Token"
  msg <- sprintf('Connected to %s with user "%s" using an API %s', conn$host, res$full_name, type)
  message(msg)

  invisible()
}

.DEFAULTS <- new.env()

#' set the default connection
#'
#' N.B: use conn=NULL to unset the default connection
#' may die on bad connection
#' @inheritParams params
#' @inheritParams connect
#' @export
set_connection <- function(conn, check = TRUE) {
  if (check && !is.null(conn)) test_connection(conn)
  assign("connection", conn, envir = .DEFAULTS)
}

#' get the default connection if any
#'
#' @param auto    whether to automatically use autoconnect() if the default connection is not yet set
#' @seealso set_connection
#' @export
get_connection <- function(auto = TRUE) {
  conn <- .DEFAULTS$connection
  if (!length(conn) && auto) {
    conn <- autoconnect()
    test_connection(conn)
    set_connection(conn, check = FALSE)
  }

  conn
}

#' connect to the QuartzBio EDP API and return the connection
#'
#' @param secret      a QuartzBio EDP **API key**  or **token** as a string.
#'                    Defaults to the `EDP_API_SECRET` environment variable if set,
#'                    otherwise to the `QUARTZBIO_ACCESS_TOKEN` var, then to `QUARTZBIO_API_KEY`, then to
#'                    legacy `SOLVEBIO_ACCESS_TOKEN` var, then to
#'                    to the `SOLVEBIO_API_KEY` var.

#' @param host        the QuartzBio EDP **API host** as a string.
#'                    Defaults to the `EDP_API_HOST` environment variable if set, otherwise to the
#'                    `QUARTZBIO_API_HOST` var, then to the legacy `SOLVEBIO_API_HOST` var.
#' @param check       whether to check the connection, mostly for debugging purposes
#' @return a connection object
#'
#' @examples \dontrun{
#' #  using API key
#' conn <- connect("MYKEY")
#' # using env vars
#' conn <- connect()
#' # using token and explicit host
#' conn <- connect("MYTOKEN", "https://xxxx.yy.com")
#' }
#'
#' @export
connect <- function(
    secret = get_env(
      "EDP_API_SECRET",
      get_env(
        "QUARTZBIO_ACCESS_TOKEN",
        get_env(
          "QUARTZBIO_API_KEY",
          get_env(
            "SOLVEBIO_ACCESS_TOKEN",
            get_env("SOLVEBIO_API_KEY")
          )
        )
      )
    ),
    host = get_env("EDP_API_HOST", get_env("QUARTZBIO_API_HOST", get_env("SOLVEBIO_API_HOST"))),
    check = TRUE) {
  conn <- list(secret = secret, host = host)
  check_connection(conn)
  if (check) test_connection(conn)

  conn
}

#' tries to connect, using environment variables or the default profile
#' @inheritParams connect
#' @seealso connect
#' @seealso read_connection_profile
#' @return the connection
#' @export
autoconnect <- function(check = FALSE) {
  conn <- try(connect(check = check), silent = TRUE)
  if (!.is_error(conn)) {
    return(conn)
  }

  # no or bad connection credentials, try the profile instead
  conn <- try(connect_with_profile(check = check), silent = TRUE)
  if (!.is_error(conn)) {
    return(conn)
  }

  stop("autoconnect() failed")
}

#' connect to the QuartzBio EDP API using a saved profile
#'
#' @inheritDotParams read_connection_profile
#' @inheritParams connect
#'
#' @export
connect_with_profile <- function(..., check = TRUE) {
  conn <- read_connection_profile(...)
  connect(conn$secret, conn$host, check = check)
}


# return an empty list if no file
read_all_connections_from_file <- function(path) {
  if (!file.exists(path)) {
    return(list())
  }
  jsonlite::read_json(path)
}


#' read a connection profile
#'
#' @inheritParams save_connection_profile
#' @return the connection for the given profile as a named list, or die if there is no such profile
#' @family connection
#' @export
read_connection_profile <- function(
    profile = get_env("EDP_PROFILE", "default"),
    path = get_env("EDP_CONFIG", "~/.qb/edp.json")) {
  profiles <- read_all_connections_from_file(path)
  cfg <- profiles[[profile]]
  .die_if(length(cfg) == 0, 'no such profile "%s" in file "%s"', profile, path)

  cfg
}

#' save a connection profile
#'
#' @inheritParams params
#' @param profile     the name of the profile, as a string
#' @param path        the path to the connection profiles file, as a string

#' @param overwrite   whether to overwrite an existing profile
#' @family connection
#' @export
save_connection_profile <- function(
    conn,
    profile = get_env("EDP_PROFILE", "default"),
    path = get_env("EDP_CONFIG", "~/.qb/edp.json"),
    overwrite = FALSE) {
  cfg <- read_all_connections_from_file(path)
  .die_unless(
    length(cfg[[profile]]) == 0 || overwrite,
    'can not overwrite existing profile "%s"', profile
  )

  cfg[[profile]] <- conn

  dir <- dirname(path)
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

  jsonlite::write_json(cfg, path, auto_unbox = TRUE)
}
