# nocov start
#' DatasetTemplate.all
#'
#' Retrieves the metadata about all dataset templates on QuartzBio EDP.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters (e.g. page).
#'
#' @examples \dontrun{
#' DatasetTemplate.all()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetTemplate.all <- function(env = get_connection(), ...) {
  .request("GET", "v2/dataset_templates", query = list(...), env = env)
}


#' DatasetTemplate.retrieve
#'
#' Retrieves the metadata about a specific dataset template on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset template.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetTemplate.retrieve(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetTemplate.retrieve <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset template ID is required.")
  }

  path <- paste("v2/dataset_templates", paste(id), sep = "/")
  .request("GET", path = path, env = env)
}


#' DatasetTemplate.delete
#'
#' Deletes a specific dataset template on QuartzBio EDP.
#'
#' @param id String The ID or full name of a QuartzBio EDP dataset template.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetTemplate.delete(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetTemplate.delete <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset template ID is required.")
  }

  path <- paste("v2/dataset_templates", paste(id), sep = "/")
  .request("DELETE", path = path, env = env)
}


#' DatasetTemplate.create
#'
#' Create a QuartzBio EDP dataset template.
#' @param env (optional) Custom client environment.
#' @param ... (optional) Dataset template attributes.
#'
#' @examples \dontrun{
#' DatasetTemplate.create(name = "My Dataset Template")
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetTemplate.create <- function(env = get_connection(), ...) {
  .request("POST", path = "v2/dataset_templates", query = NULL, body = list(...), env = env)
}


#' DatasetTemplate.update
#'
#' Updates the attributes of an existing dataset template.
#'
#' @param id The ID of the dataset template to update.
#' @param env (optional) Custom client environment.
#' @param ... Dataset template attributes to change.
#'
#' @examples \dontrun{
#' DatasetTemplate.update(
#'   id = "1234",
#'   name = "New Template Name",
#' )
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
DatasetTemplate.update <- function(id, env = get_connection(), ...) {
  if (missing(id)) {
    stop("A dataset template ID is required.")
  }

  path <- paste("v2/dataset_templates", paste(id), sep = "/")
  .request("PATCH", path = path, query = NULL, body = list(...), env = env)
}
# nocov end
