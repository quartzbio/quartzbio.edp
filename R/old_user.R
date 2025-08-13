# nocov start
#' Retrieves information about the current user
#' @inheritParams old_params
#' @concept  quartzbio_api
#' @importFrom lifecycle deprecate_soft
#' @export
User.retrieve <- function(env = get_connection()) {
  deprecate_soft("1.0.0", "User.retrieve()", "User()")
  User(conn = env)
}
# nocov end
