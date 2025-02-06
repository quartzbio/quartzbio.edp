# nocov start
#' DatasetExport.all
#'
#' Retrieves the metadata about all dataset exports on QuartzBio EDP.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters (e.g. page).
#'
#' @examples \dontrun{
#' DatasetExport.all()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetExport.all <- function(env = get_connection(), ...) {
  .request("GET", "v2/dataset_exports", query = list(...), env = env)
}

#' DatasetExport.retrieve
#'
#' Retrieves the metadata about a specific dataset export on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset export.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetExport.retrieve(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetExport.retrieve <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset export ID is required.")
  }

  path <- paste("v2/dataset_exports", paste(id), sep = "/")
  .request("GET", path = path, env = env)
}


#' DatasetExport.delete
#'
#' Deletes a specific dataset export on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset export.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetExport.delete(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetExport.delete <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset export ID is required.")
  }

  path <- paste("v2/dataset_exports", paste(id), sep = "/")
  .request("DELETE", path = path, env = env)
}


#' DatasetExport.create
#'
#' Create a new dataset export.
#'
#' @param dataset_id The target dataset ID.
#' @param format (optional) The export format (default: json).
#' @param params (optional) Query parameters for the export.
#' @param follow (default: FALSE) Follow the export task until it completes.
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional dataset export parameters.
#'
#' @examples \dontrun{
#' DatasetExport.create(
#'   dataset_id = 12345,
#'   format = "json",
#'   params = list(fields = c("field_1"), limit = 100)
#' )
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetExport.create <- function(dataset_id,
                                 format = "json",
                                 params = list(),
                                 follow = FALSE,
                                 env = get_connection(),
                                 ...) {
  if (missing(dataset_id)) {
    stop("A dataset ID is required.")
  }

  params <- list(
    dataset_id = dataset_id,
    format = format,
    params = params,
    ...
  )

  dataset_export <- .request("POST", path = "v2/dataset_exports", query = NULL, body = params, env = env)

  if (follow) {
    Task.follow(dataset_export$task_id)
  }

  return(dataset_export)
}


#' DatasetExport.get_download_url
#'
#' Helper method to get the download URL for a dataset export.
#'
#' @param id The ID of the dataset export.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetExport.get_download_url("1234567890")
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetExport.get_download_url <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset export ID is required.")
  }

  path <- paste("v2/dataset_exports", paste(id), "download", sep = "/")
  response <- .request("GET", path = path, query = list(redirect = ""), env = env)

  return(response$url)
}
# nocov end
