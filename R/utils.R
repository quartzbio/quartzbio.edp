
bless <- function(o, blessing) {
  class(o) <- blessing
  o
}

capitalize <- function(s) paste0(toupper(substring(s, 1, 1)), substring(s, 2))

# convert an EDP list to df
# - the types are applied from the first row
convert_edp_list_to_df <- function(lst) {
  if (!length(lst)) return(NULL)

  df <- as.data.frame(do.call(rbind,  lst), stringsAsFactors = FALSE)

  # N.B: use the first row to infer types
  row1 <- lst[[1]]

  for (col in seq_along(df)) {
    # only if all scalars
    if (all(lengths(df[[col]]) == 1)) 
      df[[col]] <- as(df[[col]], typeof(row1[[col]]))
  }

  df
}

retrieve_connection <- function(x) {
  conn <- attr(x, 'connection')
  if (!length(conn)) 
    conn <- get_connection()
  
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

  paste0(res, collapse = '')
}



# if x is a list with a scalar x$id item, it is returned
# otherwise x is returned
id <- function(x) {
  if (is.list(x) && length(x$id) == 1) x$id else x
}

path_make_absolute <- function(path) {
  if (!.is_nz_string(path)) return('/')
  if (substring(path, 1, 1) != '/') 
    path <- file.path('', path)
  path
}

