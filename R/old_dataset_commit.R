# nocov start
#' DatasetCommit.all
#'
#' Retrieves the metadata about all dataset commits on QuartzBio EDP.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters (e.g. page).
#'
#' @examples \dontrun{
#' DatasetCommit.all()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetCommit.all <- function(env = get_connection(), ...) {
  .request("GET", "v2/dataset_commits", query = list(...), env = env)
}


#' DatasetCommit.retrieve
#'
#' Retrieves the metadata about a specific dataset commit on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset commit.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetCommit.retrieve(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetCommit.retrieve <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset commit ID is required.")
  }

  path <- paste("v2/dataset_commits", paste(id), sep = "/")
  .request("GET", path = path, env = env)
}


#' DatasetCommit.delete
#'
#' Deletes a specific dataset commit on QuartzBio EDP.
#'
#' @param id String The ID or full name of a QuartzBio EDP dataset commit.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetCommit.delete(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetCommit.delete <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset commit ID is required.")
  }

  path <- paste("v2/dataset_commits", paste(id), sep = "/")
  .request("DELETE", path = path, env = env)
}
# nocov end
