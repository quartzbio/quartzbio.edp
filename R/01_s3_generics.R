#' @name All generics
#' @docType methods
#' @param x   the object to dispatch on
#' @inheritParams params
#' 
#' @rdname generics
NULL

#' deletes an object from EDP
#' 
#' @docType methods
#' @param x the object to delete
#' @export
#' @rdname generics
delete <- function(x, conn = attr(x, 'connection')) {
  UseMethod('delete')
}

#' @export
delete.default <- function(x, conn = attr(x, 'connection')) {
  stop('Not yet implemented')
}

#' fetches an object using its ID
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
fetch <- function(x, conn = attr(x, 'connection')) {
  UseMethod('fetch')
}

#' @export
fetch.default <- function(x, conn = attr(x, 'connection')) {
  stop('Not yet implemented')
}

#' fetches the vault related to an object
#' 
#' @docType methods
#' @return the vault, or NULL if  not applicable
#' @export
#' @rdname generics
fetch_vaults <- function(x, conn = attr(x, 'connection')) {
  UseMethod('fetch_vaults')
}

#' @export
fetch_vaults.default <- function(x, conn = attr(x, 'connection')) {
  stop('Not yet implemented')
}

