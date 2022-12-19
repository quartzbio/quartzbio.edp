### 
### vaults
#' vaults
#' @export
vaults <- function(limit = NULL, page = NULL, conn = get_connection(), ...) {
  request_edp_api('GET', "v2/vaults", conn = conn, limit = limit, page = page, params = list(...))
}


#' @inheritParams params
#' @export
vault <- function(id = NULL, full_path = NULL, path = NULL,  conn = get_connection(), ...) 
{
  by <- list(id = id, full_path = full_path, path = path)
  # no arg ==> fetch personal vault
  if (all(lengths(by) == 0)) {
    return(vault_fetch_personal(conn = conn, ...))
  }
  get_by("v2/vaults", by = by, conn = conn, ...)
}

#' @export
vault_create <- function(name,  conn = get_connection(), ...) {

}


vault_fetch_personal <- function(conn = get_connection(), ...) {
  userid <- user(conn = conn)$id
  params <- list(name = paste("user", userid, sep = "-"), vault_type = "user")
  request_edp_api('GET', "v2/vaults", conn = conn, , params = params, ...)[[1]]
}

#' @export
print.Vault <- function(x, ...) {
  msg <- sprintf('Vault "%s" @ %s (%s), user:%s updated at:%s', 
    x$name, x$full_path, x$vault_type, x$user$full_name,x$updated_at)
  cat(msg, '\n')
}

#' @export
fetch.VaultId <- function(x,  conn = get_connection()) {
  vault(x, conn = conn)
}


### 
### objects
#' @inherit Object.all
#' @inheritParams params
#' @export
objects <- function(conn = get_connection(), limit = NULL, page = NULL, ...) {
  request_edp_api('GET', "v2/objects", conn = conn, limit = limit, page = page, params = list(...))
}

#' @inherit Object.retrieve
#' @inheritParams params
#' @export
object <- function(id = NULL, full_path = NULL, path = NULL, conn = get_connection(), ...) {
  get_by("v2/objects", by = list(id = id, full_path = full_path, path = path), conn = conn, ...)
}

get_by <- function(path, by = list(), conn = NULL, ...) {
  keys <- names(by)
  with_values <- lengths(by) == 1
  nb_set <- sum(with_values)

  .die_unless(nb_set == 1, 'you must exactly one parameter among %s', keys)

  params = list(...)
  key <- keys[with_values]
  value <- by[[key]]
 
  if (key == 'id') {
    path <- file.path(path, value)
  } else {
    params[[key]] <- value
  }

  o <- request_edp_api('GET', path, conn = conn,  params = params)
  if (key != 'id') o <- o[[1]]

  o
}



# object_read_records <- function(id, filters, col.names = NULL, env = quartzbio.edp:::.config, ...) {
 

#   df
# }


#' @export
fetch.ObjectId <- function(x,  conn = get_connection()) {
  object(id = x, conn = conn)
}


#### Object methods
#' @export
print.Object <- function(x, ...) {
  msg <- sprintf('file "%s" (%s) nb:%i user:%s accessed:%s', 
    x$full_path, x$mimetype, x$documents_count, x$user$full_name, x$last_accessed)
  cat(msg, '\n')
}

###
### datasets

#' @inherit Dataset.all
#' @inheritParams params
#' @export
datasets <- function(conn = get_connection(), limit = NULL, page = NULL,  ...) {
  request_edp_api('GET', "v2/datasets", conn = conn, limit = limit, page = page, params = list(...))
}

#' @inherit Dataset.retrieve
#' @inheritParams params
#' @export
dataset <- function(id, conn = get_connection(),  ...) {
  path <- paste("v2/datasets", paste(id), sep="/")
  request_edp_api('GET', path, conn = conn,  params = list(...))
}

#' @export
print.Dataset <- function(x, ...) {
  msg <- sprintf('Dataset "%s", %i documents, updated at:%s', 
    x$full_path, x$documents_count, x$updated_at)
  cat(msg, '\n')
}

#' @export
fetch.DatasetId <- function(x,  conn = get_connection()) {
  dataset(x, conn = conn)
}




# decorate.Object <- function(x, ...) {
#   # look for ids
#   id_names <- grep('_id$', names(x), value = TRUE)
#   for (name in id_names) {
#     if (length(x[[name]])) {
#       class_name <- head(tail(strsplit(name, '_')[[1]], 2), 1)
#       class_name  <- paste0(toupper(substring(class_name, 1, 1)), substring(class_name, 2))
#       class_name <- paste0(class_name, 'Id')
#       class(x[[name]]) <- class_name

#       x
#     }
#   }

#   x
# }

# as.data.frame.Object <- function(x, row.names = NULL, optional = FALSE, ...) {
#   convert_edp_list_data_to_df(x)
# }



###
### user
#' @inherit User.retrieve
#' @inheritParams params
#' @export
user <- function(conn = get_connection()) {
  request_edp_api('GET', "v1/user", conn = conn)
}


###
### edplist
#' @export
print.edplist <- function(x, ...) {
  cat('EDP List of' , length(x), 'objects')
  if (length(x)) {
    cl <- class(x[[1]])[1]
    if (.is_nz_string(cl))
      cat(' of type', cl)
  }
  cat('\n')
  df <- convert_edp_list_data_to_df(x)
  print(df)
}

#' @export
print.VaultList <- function(x, short = TRUE, ...) {
  if (short) cat('abbreviated ')
  cat('EDP List of' , length(x), 'Vaults\n')
  df <- convert_edp_list_data_to_df(x)
  df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

  cols <- c('id', 'full_path', 'user_name', 'vault_type', 'created_at')
  if (short) {
    cols <- intersect(cols, names(df))
    df <- df[cols]
  }

  print(df)
}