#' Retrieves information about the current user
#' @inheritParams old_params
#' @export
User.retrieve <- function(env = get_connection()) {
  user(conn = env)
}

#' @inherit User.retrieve
#' @inheritParams params
#' @export
user <- function(conn = get_connection()) {
  request_edp_api('GET', "v1/user", conn = conn)
}
