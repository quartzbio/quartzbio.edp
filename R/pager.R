

offset_to_page <- function(offset, size) { ceiling(offset / size) + 1 }
page_to_offset <- function(page, size) {  (page - 1) * size }


#' fetch all the pages for a possibly incomplete paginated API result
#' 
#' @param x   an API result
#' @param verbose     whether to output debugging information, mostly for development
#' @param ... passed to future.apply::future_lapply()
#' @inheritParams params
#' @return the object resulting in combining the current object/page and all subsequent pages
#' @export
fetch_all <- function(x, ..., parallel = FALSE, workers = 4, verbose = FALSE) {
  model <- head(x, 1)
  if (parallel) {
    workers <- min(workers, 4) # hard-limit for now
    old_plan <- future::plan(future::multisession, workers = workers)
    on.exit(future::plan(old_plan), add = TRUE)
  }

  pagination <- attr(x, 'pagination') %IF_EMPTY_THEN% return(NULL)
  page_index <- pagination$page_index

  pages <- compute_next_pages(page_index)
  if (!length(pages)) return(x)

  p <- progressr::progressor(along = pages)

  fun <- function(page) {

    # this code is for multisession on dev when quartzbio.edp is not installed
    # it is not testable with covr so we exclude it from coverage
    # nocov start
    if (!require('quartzbio.edp', quietly = TRUE)) {
     
      # # we need to load quartzbio.edp in multisession plans
      # # the problem is that in dev it is not installed so we have to load it
      # # from source using qbdev
      REQUIRE <- require
      stopifnot(REQUIRE('qbdev'), 'the qbdev R package was not found in future_lapply()')
      cat('loading quartzbio.edp...\n')
      load_pkg <- utils::getFromNamespace('load_pkg', 'qbdev')
      load_pkg('quartzbio.edp')
    }
    # nocov end
    
    p(message = sprintf('page=%s', page))

    request_page <- utils::getFromNamespace('request_page', 'quartzbio.edp')
    
    request_page(model, pagination, page, verbose = verbose)
  }

  globals <- list(model = model, p = p, pagination = pagination)

  lst <- future.apply::future_lapply(pages, fun, 
    future.seed = NULL,
    future.packages ='qbdev',
    future.globals = globals,
     ...)

  lst <- c(list(x), lst)
  verbose && msg('got all results.')
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
    verbose && msg('took %s to bind the data frames', tt[3])
  } else {
    res <- do.call(c, lst)
    # apply class from x
    class(res) <- class(x)
  }

  # remove obsolete attributes
  attr(res, 'pagination')  <- attr(res, 'offset') <- attr(res, 'page')  <- attr(res, 'took') <- NULL
  
  res
}

fetch_page <- function(x, delta) {
  pagination <- attr(x, 'pagination') %IF_EMPTY_THEN% return(NULL)

  page_index <- pagination$page_index
  index <- page_index$index + delta
  if (index < 1 || index > page_index$nb) # out of range
    return(NULL)

  res <- request_page(x, pagination, index)

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
