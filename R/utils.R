bless <- function(o, ...) {
  if (!length(o)) o <- data.frame()
  class(o) <- c(list(...), class(o))
  o
}

# transform the multi-values entries of a named list into single-valued
# by repeating the names if needed
# e.g. list(a = 1, b = 1:3) --> list(a = 1, b = 1, b = 2, b = 3)
scalarize_list <- function(lst) {
  if (.empty(lst)) {
    return(lst)
  }

  # locate the multi-valued entries
  multi_idx <- which(lengths(lst) > 1)
  if (.empty(multi_idx)) {
    return(lst)
  }

  .scalarize <- function(idx) {
    v <- unlist(lst[[idx]], recursive = TRUE, use.names = FALSE)
    v <- as.list(v)
    # N.B: may be NULL
    names(v) <- rep(names(lst)[idx], length(v))

    v
  }

  res <- lapply(multi_idx, .scalarize)
  scalar_lst <- Reduce(c, res, list())

  c(lst[-multi_idx], scalar_lst)
}



# inspired by from wkb:::.hex2raw
hex2raw <- function(hex) {
  msg <- "hex is not a valid hexadecimal representation"
  .die_unless(length(hex) > 0, msg)

  # sanitize
  hex <- gsub("[^0-9a-fA-F]", "", hex)
  if (length(hex) == 1) { # single string, split it to a vector of strings
    nb <- nchar(hex)
    .die_unless(nb > 0 && nb %% 2 == 0, msg)
    hex <- strsplit(hex, "")[[1]]
    hex <- paste0(hex[c(TRUE, FALSE)], hex[c(FALSE, TRUE)])
  }
  .die_unless(all(nchar(hex) == 2), msg)

  as.raw(as.hexmode(hex))
}

capitalize <- function(s) paste0(toupper(substring(s, 1, 1)), substring(s, 2))

# convert an EDP list to df
# - the types are applied from the first row
convert_edp_list_to_df <- function(lst) {
  if (!length(lst)) {
    return(NULL)
  }

  df <- as.data.frame(do.call(rbind, lst), stringsAsFactors = FALSE)

  # N.B: use the first row to infer types
  row1 <- lst[[1]]

  for (col in seq_along(df)) {
    # only if all scalars
    if (all(lengths(df[[col]]) == 1)) {
      df[[col]] <- as(df[[col]], typeof(row1[[col]]))
    }
  }

  df
}

retrieve_connection <- function(x) {
  conn <- attr(x, "connection")
  if (!length(conn)) {
    conn <- get_connection()
  }

  conn
}

# intended for permissions
summary_string <- function(lst) {
  ns <- names(lst)
  .fetch_value <- function(name) {
    x <- substr(name, 1, 1)
    if (isTRUE(lst[[name]])) toupper(x) else tolower(x)
  }
  res <- lapply(ns, .fetch_value)

  paste0(res, collapse = "")
}



# if x is a list with a scalar x$id item, it is returned
# otherwise x is returned
id <- function(x) {
  if (is.list(x) && length(x$id) == 1) x$id else x
}

path_make_absolute <- function(path) {
  if (!.is_nz_string(path)) {
    return("/")
  }
  if (substring(path, 1, 1) != "/") {
    path <- file.path("", path)
  }
  path
}

# fast unlist
unlist1 <- function(x) unlist(x, recursive = FALSE, use.names = FALSE)

elts <- function(objects, name_or_idx) {
  lapply(objects, getElement, name_or_idx)
}

msg <- function(...) {
  message(.safe_sprintf(...))
}

build_httr_response <- function(
    url,
    code = 200L,
    headers = list(`content-type` = "application/json"),
    content = NULL) {
  structure(
    list(
      url = url,
      status_code = code,
      headers = headers,
      content = content
    ),
    class = "response"
  )
}

`%IF_EMPTY_THEN%` <- function(a, b) {
  if (!length(a)) b else a
}

is_defined_scalar_integer <- function(x) {
  length(x) == 1 && is.numeric(x) && is.finite(x) && as.integer(x) == x
}

`%UNLESS_TRUE_INT%` <- function(a, b) {
  if (is_defined_scalar_integer(a)) a else b
}
