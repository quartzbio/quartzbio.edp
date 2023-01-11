

#' @export
fetch_next.edpdf <- function(x) {
  fun <- attr(x, 'next')
  if (!length(fun)) return(NULL)
  fun()
}

#' @export
fetch_all.edpdf <- function(x) {
  # naive implementation
  dfs <- list(x)
  while(length(x <- fetch_next(x))) dfs <- c(dfs, list(x))

  df <- do.call(rbind.data.frame, dfs)
  # recompute took
  took <- sum(sapply(dfs, attr, 'took'))
  attr(df, 'took') <- took
  # remove obsolete attributes
  attr(df, 'offset') <- attr(df, 'next') <- NULL

  df
}
