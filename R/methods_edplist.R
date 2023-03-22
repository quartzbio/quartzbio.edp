

edplist <- function(x) {
  bless(x, 'edplist', 'edp') 
}


#' @export
print.edplist <- function(x, ...) {
  cat('EDP List of' , length(x), 'objects')

  if (length(x)) {
    cl <- class(x[[1]])[1]
    if (.is_nz_string(cl))
      cat(' of type', cl)

    cat('\n')
    df <- convert_edp_list_to_df(x)
    print(df)
  } else {
    cat('\n')
  }
}

#' @export
as.data.frame.edplist <- function(x,  ...) {
  convert_edp_list_to_df(x)
}
