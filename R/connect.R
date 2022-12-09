
get_env <- function(name, unset = '') {
  vx <- Sys.getenv(name)
  if (.is_nz_string(vx)) vx else unset
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
