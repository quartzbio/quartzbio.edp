.is_nz_string  <- function(x) { length(x) == 1 && !is.na(x) && is.character(x) && nzchar(x)  }

.die_if  <- function(cond, ..., .envir = parent.frame()) .die_unless(!cond, ..., .envir = .envir)
.die_unless <- function(cond, ..., .envir = parent.frame()) {
	if (!is.logical(cond) || empty(cond)) {
		stop("Bad logical argument cond: ", cond)
	}

  # check that the dots are not forgotten
  if (missing(...)) stop('missing message')

	if (any(!cond)) .die(..., .envir = .envir)

	invisible()
}

.die <- function(..., qblog = FALSE, .envir = parent.frame()) {
  
	msg <- .build_error_message(..., .envir = .envir)
  if (qblog) qblog_error(msg)
	stop(msg, call. = FALSE)
}

.build_error_message <- function(fmt, ..., .envir = parent.frame()) {
  # we can not afford to die when building the message error for die !
  msg <- try(safe_sprintf(fmt, ...))
  if (is_error(msg)) {
    msg <- sprintf('could not build error message: "%s"', get_error_msg(msg))
  }

  msg
}

.safe_sprintf <- function(fmt, ...) {
  if (length(fmt) != 1) {
    stop('Arg "format" must be a scalar (length 1)')
  }

  dots <- list(...)
  if (empty(dots)) return(fmt)

  .collapse_args <- function(x) {
    if (length(x) > 1) paste0(x, collapse = ',') else
      if (length(x) == 0) '' else x
  }
  fixed_dots <- lapply(dots, .collapse_args)

  do.call(sprintf, c(list(fmt), fixed_dots))
}
