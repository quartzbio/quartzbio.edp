


offset_to_page <- function(offset, size) { ceiling(offset / size) + 1 }
page_to_offset <- function(page, size) {  (page - 1) * size }


# util
pager <- function(x) attr(x, 'pager')


fetch_page <- function(x, delta) {
  pager <- attr(x, 'pager') %IF_EMPTY_THEN% return(NULL)
  page_index <- pager()
  index <- page_index$index + delta
  if (index >= 1 && index <= page_index$nb) pager(index) else NULL
}

#' fetch all the pages for a possibly incomplete paginated API result
#' 
#' @param x   an API result
#' @return the object resulting in combining the current object/page and all subsequent pages
#' @export
fetch_all <- function(x) {
  pager <- pager(x) %IF_EMPTY_THEN% return(NULL)
  page_index <- pager()

  pages <- compute_next_pages(page_index)
  if (!length(pages)) return(x)

  lst <- future.apply::future_lapply(pages, pager)
  lst <- c(list(x), lst)

  # how to bind results ?
  # current naive implementation
  res <- NULL
  if (is.data.frame(lst[[1]])) {
    res <- do.call(rbind.data.frame, lst)
  } else {
    res <- do.call(c, lst)
    # apply class from x
    class(res) <- class(x)
  }

  # remove obsolete attributes
  attr(res, 'pager')  <- attr(res, 'offset') <- attr(res, 'page')  <- attr(res, 'took') <- NULL
  
  res
}

#' fetch the next page of data if any
#' 
#' @inheritParams fetch_all
#' @return the next page of data, or NULL if none 
#' @export
fetch_next <- function(x) {
  fetch_page(x, 1L)
}

#' fetch the previous page of data if any
#' 
#' @inheritParams fetch_all
#' @return the previous page of data, or NULL if none 
#' @export
fetch_prev <- function(x) {
  fetch_page(x, -1L)
}


compute_next_pages <- function(pi) {
  start <- pi$index + 1L
  nb <- pi$nb
  if (start <= nb) seq.int(start, nb) else NULL
}
