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



#' fetch an object from its ID
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

