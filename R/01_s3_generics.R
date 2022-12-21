#' @name All generics
#' @docType methods
#' @rdname generics
NULL


#' decorate object
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
decorate <- function(x) {
  UseMethod('decorate')
}


#' @export
decorate.default <- function(x, ...) {
  # look for ids
  id_names <- grep('_id$', names(x), value = TRUE)
  for (name in id_names) {
    if (length(x[[name]])) {
      class_name <- head(tail(strsplit(name, '_')[[1]], 2), 1)
      class_name  <- paste0(toupper(substring(class_name, 1, 1)), substring(class_name, 2))
      class_name <- paste0(class_name, 'Id')
      class(x[[name]]) <- class_name

      x
    }
  }

  x
}



#' delete an object from EDP
#' 
#' @docType methods
#' @param x the object to delete
#' @export
#' @rdname generics
delete <- function(x, conn = get_connection()) {
  UseMethod('delete')
}

#' @export
delete.default <- function(x,  conn = get_connection()) {
  stop('Not yet implemented')
}

#' fetch an object using its ID
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
fetch <- function(x, conn = get_connection()) {
  UseMethod('fetch')
}

#' @export
fetch.default <- function(x,  conn = get_connection()) {
  stop('Not yet implemented')
}

#' fetch the next one
#' 
#' @docType methods
#' @return the decorated object
#' @export
#' @rdname generics
fetch_next <- function(x) {
  UseMethod('fetch_next')
}

#' fetch the vault related to an object
#' 
#' @docType methods
#' @return the vault, or NULL if  not applicable
#' @export
#' @rdname generics
fetch_vaults <- function(x, conn = get_connection()) {
  UseMethod('fetch_vaults')
}

#' @export
fetch_vaults.default <- function(x,  conn = get_connection()) {
  NULL
}