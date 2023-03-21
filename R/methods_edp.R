


fetch_url <- function(x, direction, conn) {
  # first check if there is a prev/next function
  fun <- attr(x, direction)
  if (is.function(fun)) return(fun())

  links <- attr(x, 'links')
  if (!length(links) || !length(links[[direction]])) return(NULL)

  # N.B: since the pointer is integrated in the URI, set it to NULL not to overwrite
  # those URI encoded values
  request_edp_api('GET', uri = links[[direction]], conn = conn, pointer = NULL)
}

# #' @export
# fetch_next.edp <- function(x,  conn = retrieve_connection(x)) {
#   res <- fetch_url(x, 'next', conn)
#   if (length(res)) res else NULL
# }

# #' @export
# fetch_prev.edp <- function(x,  conn = retrieve_connection(x)) {
#   res <- fetch_url(x, 'prev', conn)
#   if (length(res)) res else NULL
# }

#' fetch all next chunks/pages of data and aggregate them in a single data chunk
#' @param x   a chunk of data
#' @return the aggregated data chunks/pages
#' @export
fetch_all.edp <- function(x) {
  # naive implementation
  x0 <- x
  res <- x
  while(length(x <- fetch_next(x))) res <- c(res, x)

  attrs <- attributes(x0)
  keys <- setdiff(names(attrs), c('links', 'url', 'prev', 'next'))
  for (key in keys) attr(res, key) <- attrs[[key]]

  res
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
as.data.frame.edplist <- function (x,  ...) {
  convert_edp_list_to_df(x)
}
