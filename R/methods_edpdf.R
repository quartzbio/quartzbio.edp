edpdf <- function(x) {
  bless(x, 'edpdf', 'edp') 
}


#' @export
fetch_all.edpdf <- function(x) {
  # naive implementation
  dfs <- list(x)
  while(length(x <- fetch_next(x))) dfs <- c(dfs, list(x))

  df <- do.call(rbind.data.frame, dfs)

  # remove obsolete attributes
  attr(df, 'next') <- attr(df, 'prev') <- NULL

  df
}



