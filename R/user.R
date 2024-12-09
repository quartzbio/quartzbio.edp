#' fetches  user information.
#' @inheritParams params
#' @return the connected user information as a User object
#' @export
User <- function(conn = get_connection()) {
  request_edp_api("GET", "v1/user", conn = conn)
}

#' @export
print.User <- function(x, ...) {
  msg <- sprintf('EDP user "%s"(%s) role:%s', x$full_name, x$username, x$role)
  cat(msg, "\n")
}

#' @export
fetch_vaults.User <- function(x, conn = get_connection()) {
  Vaults(user_id = x$id, conn = conn)
}

#' @export
fetch_vaults.UserId <- function(x, conn = get_connection()) {
  Vaults(user_id = x, conn = conn)
}
