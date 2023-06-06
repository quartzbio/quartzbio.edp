# nocov start
#' SavedQuery.all
#'
#' Retrieves the all saved queries on QuartzBio EDP.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters (e.g. page).
#'
#' @examples \dontrun{
#' SavedQuery.all()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
SavedQuery.all <- function(env = get_connection(), ...) {
    .request('GET', "v2/saved_queries", query=list(...), env=env)
}


#' SavedQuery.retrieve
#'
#' Retrieves a specific saved query on QuartzBio EDP by ID.
#'
#' @param id String The ID of a QuartzBio EDP saved query.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' SavedQuery.retrieve(<ID>)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
SavedQuery.retrieve <- function(id, env = get_connection()) {
    if (missing(id)) {
        stop("A saved query ID is required.")
    }

    path <- paste("v2/saved_queries", paste(id), sep="/")
    .request('GET', path=path, env=env)
}


#' SavedQuery.delete
#'
#' Deletes a specific saved query on QuartzBio EDP.
#'
#' @param id String The ID of the QuartzBio EDP saved query.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' SavedQuery.delete(<ID>)
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
SavedQuery.delete <- function(id, env = get_connection()) {
    if (missing(id)) {
        stop("A saved query ID is required.")
    }

    path <- paste("v2/saved_queries", paste(id), sep="/")
    .request('DELETE', path=path, env=env)
}


#' SavedQuery.create
#'
#' Create a QuartzBio EDP saved query.
#' @param env (optional) Custom client environment.
#' @param ... (optional) Saved query attributes.
#'
#' @examples \dontrun{
#' SavedQuery.create(name="My Dataset Template")
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
SavedQuery.create <- function(env = get_connection(), ...) {
    .request('POST', path='v2/saved_queries', query=NULL, body=list(...), env=env)
}


#' SavedQuery.update
#'
#' Updates the attributes of an existing saved query.
#'
#' @param id The ID of the saved query to update.
#' @param env (optional) Custom client environment.
#' @param ... Saved query attributes to change.
#'
#' @examples \dontrun{
#' SavedQuery.update(
#'                id="1234",
#'                name="New query Name",
#'               )
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  solvebio_api
#' @export
SavedQuery.update <- function(id, env = get_connection(), ...) {
    if (missing(id)) {
        stop("A saved query ID is required.")
    }

    path <- paste("v2/saved_queries", paste(id), sep="/")
    .request('PATCH', path=path, query=NULL, body=list(...), env=env)
}
# nocov end
