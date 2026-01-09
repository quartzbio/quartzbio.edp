# nocov start
#' DatasetImport.all
#'
#' Retrieves the metadata about all dataset imports on QuartzBio EDP.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters (e.g. page).
#'
#' @examples \dontrun{
#' DatasetImport.all()
#' }
#'
#' @concept  quartzbio_api
#' @export
DatasetImport.all <- function(env = get_connection(), ...) {
  .request("GET", "v2/dataset_imports", query = list(...), env = env)
}


#' DatasetImport.retrieve
#'
#' Retrieves the metadata about a specific dataset import on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset import.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetImport.retrieve(12345)
#' }
#'
#' @concept  quartzbio_api
#' @export
DatasetImport.retrieve <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset import ID is required.")
  }

  path <- paste("v2/dataset_imports", paste(id), sep = "/")
  .request("GET", path = path, env = env)
}


#' DatasetImport.delete
#'
#' Deletes a specific dataset import on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset import.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetImport.delete(12345)
#' }
#'
#' @concept  quartzbio_api
#' @export
DatasetImport.delete <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset import ID is required.")
  }

  path <- paste("v2/dataset_imports", paste(id), sep = "/")
  .request("DELETE", path = path, env = env)
}


#' DatasetImport.create
#'
#' Create a new dataset import. Either an object_id, manifest, or data_records is required.
#'
#' @param dataset_id The target dataset ID.
#' @param commit_mode (optional) The commit mode (default: append).
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional dataset import attributes.
#'
#' @examples \dontrun{
#' DatasetImport.create(dataset_id = 12345, upload_id = 12345)
#' }
#'
#' @importFrom lifecycle deprecate_soft
#' @concept  quartzbio_api
#' @export
DatasetImport.create <- function(dataset_id,
                                 commit_mode = "append",
                                 env = get_connection(),
                                 ...) {
  deprecate_soft("1.0.0", "DatasetImport.create()", "Dataset_import()")
  if (missing(dataset_id)) {
    stop("A dataset ID is required.")
  }

  params <- list(
    dataset_id = dataset_id,
    commit_mode = commit_mode,
    ...
  )

  dataset_import <- .request("POST", path = "v2/dataset_imports", query = NULL, body = params, env = env)

  dataset_import
}
# nocov end
