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


#' fetches the next chunk of data/page
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
fetch_next <- function(x) {
  UseMethod('fetch_next')
}


#' @export
fetch_next.default <- function(x) {
  fetch_page(x, 1L)
}

#' fetches the previous chunk of data/page
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
fetch_prev <- function(x) {
  UseMethod('fetch_prev')
}

#' @export
fetch_prev.default <- function(x) {
  fetch_page(x, -1L)
}

fetch_page <- function(x, delta) {
  pager <- attr(x, 'pager') %IF_EMPTY_THEN% return(NULL)
  page_index <- pager()
  index <- page_index$index + delta
  if (index < 1 || index > page_index$nb) NULL else pager(index)
}


#' fetches all next chunks/pages of data and aggregate them in a single data chunk
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
fetch_all <- function(x) {
  UseMethod('fetch_all')
}

#' @export
fetch_all.default <- function(x) {
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

