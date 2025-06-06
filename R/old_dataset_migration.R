# nocov start
#' DatasetMigration.all
#'
#' Retrieves the metadata about all dataset migrations on QuartzBio EDP.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters (e.g. page).
#'
#' @examples \dontrun{
#' DatasetMigration.all()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetMigration.all <- function(env = get_connection(), ...) {
  .request("GET", "v2/dataset_migrations", query = list(...), env = env)
}


#' DatasetMigration.retrieve
#'
#' Retrieves the metadata about a specific dataset migration on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset migration.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetMigration.retrieve(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetMigration.retrieve <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset migration ID is required.")
  }

  path <- paste("v2/dataset_migrations", paste(id), sep = "/")
  .request("GET", path = path, env = env)
}


#' DatasetMigration.delete
#'
#' Deletes specific dataset migration on QuartzBio EDP.
#'
#' @param id String The ID of a QuartzBio EDP dataset migration.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' DatasetMigration.delete(12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetMigration.delete <- function(id, env = get_connection()) {
  if (missing(id)) {
    stop("A dataset migration ID is required.")
  }

  path <- paste("v2/dataset_migrations", paste(id), sep = "/")
  .request("DELETE", path = path, env = env)
}


#' DatasetMigration.create
#'
#' Create a new dataset migration.
#'
#' @param source_id The source dataset ID.
#' @param target_id The target dataset ID.
#' @param commit_mode (optional) The commit mode (default: append).
#' @param source_params (optional) The query parameters used on the source dataset.
#' @param target_fields (optional) A list of valid dataset fields to add or override in the target dataset.
#' @param include_errors (optional) If TRUE, a new field (_errors) will be added to each record containing expression evaluation errors (default: FALSE).
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional dataset migration attributes.
#'
#' @examples \dontrun{
#' DatasetMigration.create(dataset_id = 12345, upload_id = 12345)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
DatasetMigration.create <- function(source_id,
                                    target_id,
                                    commit_mode = "append",
                                    source_params = NULL,
                                    target_fields = NULL,
                                    include_errors = FALSE,
                                    env = get_connection(),
                                    ...) {
  if (missing(source_id)) {
    stop("A source dataset ID is required.")
  }

  if (missing(target_id)) {
    stop("A target dataset ID is required.")
  }

  params <- list(
    source_id = source_id,
    target_id = target_id,
    source_params = source_params,
    target_fields = target_fields,
    commit_mode = commit_mode,
    include_errors = include_errors,
    ...
  )

  dataset_migration <- .request("POST", path = "v2/dataset_migrations", query = NULL, body = params, env = env)

  return(dataset_migration)
}
# nocov end
