
get_env <- function(name, unset = '') {
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
  .die_unless(length(conn) >= 1, 'bad connection')
  ns <- names(conn)
  .die_unless('secret' %in% ns, 'no "secret" in connection')
  .die_unless('host' %in% ns, 'no "host" in connection')

  secret <- conn$secret
  .die_unless(.is_nz_string(secret), 'bad "secret" in connection')
  .die_unless(.is_nz_string(conn$host), 'bad "host" in connection')

  .die_unless(looks_like_api_key(secret) || looks_like_api_token(secret), 
    'connection secret does not look like an API key or token')
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
  res <- try(request_edp_api('GET', "v1/user", conn = conn))
  if (.is_error(res)) {
    warning(paste('got error connecting:', .get_error_msg(res)))
    return(FALSE)
  }

  type <- if (looks_like_api_key(conn$secret)) 'Key' else 'Token'
  msg <- sprintf('Connected to %s with user "%s" using an API %s', conn$host, res$full_name, type)
  message(msg)

  TRUE
}



new_connection  <- function(
  api_key = get_env('EDP_API_KEY',get_env('SOLVEBIO_API_KEY')),
  api_token = get_env('EDP_API_TOKEN', get_env('SOLVEBIO_API_TOKEN')),
  api_host = get_env('EDP_API_HOST',get_env('SOLVEBIO_API_HOST', "https://sandbox.api.edp.aws.quartz.bio")))
{
  .die_if(!missing(api_key) && !missing(api_token), 'you can not give both api_key and api_token')

  # give priority to key
  secret <- NULL
  is_key <- TRUE
  # choose api_key if defined unl
  if (.is_nz_string(api_key) && missing(api_token)) {
    secret <- api_key
  } else if (.is_nz_string(api_token)) {
    secret <- api_token
    is_key <- FALSE
  }
  .die_unless(.is_nz_string(secret), 'you must give either an API Key or an API Token')

  list(secret = secret, is_key = is_key, host = api_host)
}


#' connect to the QuartzBio EDP API
#' 
#' There are multiple ways to connect:
#' - using an API key or token
#' - using a connection config
#' - using a saved connection profile
#'
#' @param api_key      a QuartzBio EDP **API key** as a string. 
#'                     Defaults to the `EDP_API_KEY` environment variable if set, otherwise to the 
#'                    legacy `SOLVEBIO_API_KEY`.
#' @param api_token    a QuartzBio EDP **API access token** as a string.
#'                    Defaults to the `EDP_API_TOKEN` environment variable if set, otherwise to the 
#'                    legacy `SOLVEBIO_API_TOKEN`.
#' @param api_host    the QuartzBio EDP **API host** as a string. 
#'                    Defaults to the `EDP_API_HOST` environment variable if set, otherwise to the 
#'                    legacy `SOLVEBIO_API_HOST`
#' @return a connection object
#' 
#' @examples \dontrun{
#'    conn <- connect(api_key = 'MYKEY')
#'    # using env vars
#'    conn <- connect()
#'    # using token and explicit host
#'    conn <- connect(api_token = 'MYTOKEN', api_host = 'https://xxxx.yy.com')
#' }
#'
#' @export
connect <- function(...) {
  conn <- new_connection(...)
  # browser()
    # # Test the login
    # tryCatch({
    #     user <- User.retrieve(env=env)
    #     cat(sprintf("Logged-in to %s as %s.\n", env$host, user$email))
    #     return(invisible(user))
    # }, error = function(e) {
    #     cat(sprintf("Login failed: %s\n", e$message))
    # })
}

#' connect to the QuartzBio EDP API using a saved profile
#' 
#' @inheritDotParams read_connection_profile
#' 
#' @export
connect_with_profile <- function(...) {
  conn <- read_connection_profile(...)
  
}


# return an empty list if no file
read_all_connections_from_file <- function(path) {
  if (!file.exists(path)) return(list())
  jsonlite::read_json(path)
}

#' read a connection profile
#' 
#' @inheritParams save_connection_profile
#' @return the connection for the given profile as a named list, or die if there is no such profile
#' @family connection
#' @export
read_connection_profile <- function(profile = 'default', path = '~/.qb/edp.json') {
  profiles <- read_all_connections_from_file(path)
  cfg <- profiles[[profile]]
  .die_if(length(cfg) == 0, 'no such profile "%s" in file "%s"', profile, path)

  cfg
}

#' save a connection profile
#' 
#' @param path        the path to the connection profiles file, as a string
#' @param profile     the name of the profile, as a string
#' @param overwrite   whether to overwrite an existing profile
#' @family connection
#' @export
save_connection_profile <- function(conn, 
  profile = 'default', 
  path = '~/.qb/edp.json', 
  overwrite = FALSE) 
{
  cfg <- read_all_connections_from_file(path)
  .die_unless(length(cfg[[profile]]) == 0 || overwrite, 
    'can not overwrite existing profile "%s"', profile) 

  cfg[[profile]] <- conn

  jsonlite::write_json(cfg, path, auto_unbox = TRUE)
}

