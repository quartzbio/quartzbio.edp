# nocov start
#' Retrieves information about the current user
#' @inheritParams old_params
#' @concept  quartzbio_api
#' @export
User.retrieve <- function(env = get_connection()) {
  User(conn = env)
}
# nocov end
