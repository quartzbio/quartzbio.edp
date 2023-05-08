


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
#' @param ... passed to future.apply::future_lapply()
#' @return the object resulting in combining the current object/page and all subsequent pages
#' @export
fetch_all <- function(x, ...) {
  pager <- pager(x) %IF_EMPTY_THEN% return(NULL)
  page_index <- pager()

  pages <- compute_next_pages(page_index)
  if (!length(pages)) return(x)

  p <- progressr::progressor(along = pages)

  fun <- function(x) {
    if (!require('quartzbio.edp')) {
      # we need to load quartzbio.edp in multisession plans
      # the problem is that in dev it is not installed so we have to load it
      # from source using qbdev
      .die_unless(require('qbdev'), 'the quartzbio.edp R package was not found in future_lapply()')
     
      # qbdev is not declared as dependency, so we have to hack
      ns <- getNamespace()
      load_pkg <- get('load_pkg', ns)
      load_pkg('quartzbio.edp')
    }
    p(sprintf('page=%s', x))
    pager(x)
  }

  lst <- future.apply::future_lapply(pages, fun, 
    future.seed = NULL, 
    # future.packages ='quartzbio.edp',
     ...)

  lst <- c(list(x), lst)
  msg('got all results.')
  # how to bind results ?
  # current naive implementation
  res <- NULL
  if (is.data.frame(lst[[1]])) {
    # implement fastest method with fallback in case of error
    tt <- system.time(res <- try(as.data.frame(dplyr::bind_rows(lst)), TRUE), gcFirst = FALSE)
    if (.is_error(res)) {
      # errors may happen for example if the JSON data type vary across pages
      # cf https://precisionformedicine.atlassian.net/browse/SBP-536
      warning(.safe_sprintf('got error using dplyr::bind_rows() to aggregate the paginated results: "%s"', 
        .get_error_msg(res)))

      msg('got error using dplyr::bind_rows() to aggregate the paginated results, retrying with rbind.data.frame()...')
      tt <- system.time(res <- do.call(rbind.data.frame, lst), FALSE)
    }
    msg('took %s to bind the data frames', tt[3])
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
