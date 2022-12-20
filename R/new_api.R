### 
### folders
# get folders
#' @inheritParams params
#' @export
folders <- function(vault_id = NULL, ...) {
  objects(object_type = 'folder', vault_id = vault_id, ...)
}

# get a folder
#' @inheritParams params
#' @export
folder <- function(id = NULL, full_path = NULL, path = NULL, vault_id = NULL, 
  conn = get_connection(), ...) 
{
  if (length(id)) return(object(id = id, conn = get_connection(), ...))

  objects(object_type = 'folder', vault_id = vault_id, ...)
}


# get a folder
#' @inheritParams params
#' @export
folder <- function(...) {  object(...) }

#' create folder
#' @export
folder_create <- function(vault_id, path, recursive = TRUE, parent_folder_id = NULL, ...,
  conn = get_connection()) 
{
  path <- path_make_absolute(path)
  parent_path <- dirname(path)
  folders <- strsplit(path, '/', fixed = TRUE)[[1]][-1]
  if (!length(parent_folder_id) && parent_path != '/') {
    parent <- folder(path = parent_path, vault_id = vault_id, conn = conn)
    .die_if(!length(parent) && !recursive, 'not allowed to create parent folder (recursive == FALSE)')
    if (!length(parent)) {
      parent <- folder_create(vault_id, parent_path, recursive = recursive, conn = conn, ...)
    }
    parent_folder_id <- parent$id
  }
  object_create(vault_id = vault_id, filename = basename(path), object_type = 'folder', 
    parent_object_id = parent_folder_id, ..., conn = conn)
}

### 
### files
# get folders
#' @inheritParams params
#' @export
files <- function(vault_id = NULL, ...) {
  objects(object_type = 'file', vault_id = vault_id, ...)
}



#' @export
file_upload <- function(vault_id, local_path, vault_path, 
  mimetype = mime::guess_type(local_path),
  conn = get_connection(), ...) 
{
  vault_path <- path_make_absolute(vault_path)
  filename <- basename(vault_path)
  .die_unless(.is_nz_string(filename), 'bad vault_path "%s"', vault_path)
  .die_unless(file.exists(local_path), 'bad vault_path "%s"', vault_path)
  size <- file.size(local_path)
  force(mimetype)

  parent_path <- dirname(vault_path)
  parent_folder_id <- NULL
  if (parent_path != '/') {
    # must get a folder

    fo <- folder(path = parent_path, vault_id = vault_id, conn = conn)
    if (!length(fo)) {
      # no parent --> create it
      fo <- folder_create(vault_id, parent_path, conn = conn)
    }
    parent_folder_id <- fo$id
  }

  # create object for the file
  
  obj <- object_create(vault_id, filename, 
    object_type = 'file', 
    parent_object_id = parent_folder_id,
    size = size, 
    mimetype = mimetype, 
    conn = conn, ...)
  
  res <- try(file_upload_content(obj$upload_url, local_path, size = size, mimetype = mimetype, 
    conn = conn))

  if (.is_error(res) || res$status != 200) {
    warning('deleting object file because uploading file content failed...')
    delete(obj, conn = conn)

    if (.is_error(res)) stop(res)
    err <- get_api_response_error_message(res)
    .die('uploading file content failed with code %s: %s', res$status, err)

  }

  obj
}

file_upload_content <- function(upload_url, path, size, mimetype, conn) {
  message('uploading file', path, '...') 
  headers <- c('Content-Type' = mimetype, 'Content-Length' = size)
  PUT(upload_url, add_headers(headers), body = upload_file(path, type = mimetype))
}

#' @export
file_read <- function(id, filters = NULL, limit = NULL, page = NULL, conn = get_connection(), ...) {
  request_edp_api('POST', file.path("v2/objects", id, 'data'), filters = filters, 
      simplifyDataFrame = TRUE, conn = conn)
}




### 
### vaults
#' vaults
#' @export
vaults <- function(
  vault_type = c('personal', 'general'),
  tag = NULL,
  user_id = NULL,
  storage_class = NULL,
  limit = NULL, page = NULL, conn = get_connection(), ...) 
{
  params  <- list()
  if (.is_nz_string(vault_type)) params$vault_type <- vault_type
  if (.is_nz_string(tag)) params$tags <- tag
  if (length(user_id)) params$user_id <- user_id
  if (.is_nz_string(storage_class)) params$storage_class <- storage_class
  request_edp_api('GET', "v2/vaults", conn = conn, limit = limit, page = page, params = params, ...)
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

#' cf https://docs.solvebio.com/reference/vaults/vaults/#create
#' @export
vault_create <- function(name,  
  description = NULL,
  metadata = NULL,
  tags = NULL,
  default_storage_class = NULL,
  conn = get_connection(), 
  ...) 
{
  params <- preprocess_api_params()
  request_edp_api('POST', "v2/vaults", conn = conn, params = params, ...)
}

#' @export
vault_update <- function(id,  
  name = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  default_storage_class = NULL,
  conn = get_connection(), 
  ...) 
{
  params <- preprocess_api_params()
  request_edp_api('PUT', file.path("v2/vaults", id), conn = conn, params = params, ...)
}

# vault_create_or_update <- function(id = NULL, name = NULL, description = NULL,
#   metadata = NULL,
#   tags = NULL, 
#   default_storage_class = c('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive'),
#   conn = get_connection(),
#   ...) 
# {
#   params <- list()
#   if (.is_nz_string(name)) params$name <- name
#   if (length(default_storage_class)) {
#     default_storage_class <- match.arg(default_storage_class)
#     if (.is_nz_string(default_storage_class)) params$default_storage_class <- default_storage_class
#   }
#   if (.is_nz_string(description)) params$description <- description
#   if (.is_nz_string(tags)) params$tags <- tags
#   if (length(metadata)) params$metadata <- metadata

#   method <- 'POST'
#   path <-"v2/vaults"
#   if (length(id)) {
#     method <- 'PUT'
#     path <- file.path(path, id)
#   }

#   request_edp_api(method, path, conn = conn, params = params, ...)
# }



vault_fetch_personal <- function(conn = get_connection(), ...) {
  userid <- user(conn = conn)$id
  params <- list(name = paste("user", userid, sep = "-"), vault_type = "user")
  request_edp_api('GET', "v2/vaults", conn = conn, params = params, ...)[[1]]
}

vault_delete <- function(id, conn = get_connection(), ...) {
  request_edp_api('DELETE', file.path("v2/vaults", id), conn = conn, ...)
}

#' @export
update.Vault <- function(object, conn = get_connection(), ...) {
  vault_update(object$id, conn = conn, ...)
}

#' @export
update.VaultId <- function(object, conn = get_connection(), ...) {
  vault_update(object, conn = conn, ...)
}

#' @export
delete.Vault <- function(x, conn = get_connection()) {
  vault_delete(x$id, conn = conn)
}

#' @export
delete.VaultId <- function(x,  conn = get_connection()) {
  vault_delete(x, conn = conn)
}

#' @export
print.Vault <- function(x, ...) {
  msg <- sprintf('Vault "%s" @ %s (%s), user:%s updated at:%s', 
    x$name, x$full_path, x$vault_type, x$user$full_name,x$updated_at)
  cat(msg, '\n')
}

#' @export
print.VaultList <- function(x, short = TRUE, ...) {
  if (short) cat('abbreviated ')
  cat('EDP List of' , length(x), 'Vaults\n')
  df <- as.data.frame(x)
  df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

  cols <- c('id', 'full_path', 'user_name', 'vault_type', 'created_at')
  if (short) {
    cols <- intersect(cols, names(df))
    df <- df[cols]
  }

  print(df)
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
objects <- function(
  vault_id = NULL,
  vault_name = NULL,
  vault_full_path = NULL,
  filename = NULL,
  path = NULL,
  object_type = NULL,
  depth = NULL,
  query = NULL,
  regex = NULL,
  glob = NULL,
  ancestor_id = NULL,
  min_distance = NULL,
  tag = NULL,
  storage_class = NULL,
  conn = get_connection(), limit = NULL, page = NULL, ...) 
{
  params  <- preprocess_api_params()
  request_edp_api('GET', "v2/objects", conn = conn, limit = limit, page = page, params = params, ...)
}

preprocess_api_params <- function(
  exclude = c('conn', 'limit', 'page'), 
  match_args = list(
    object_type = c('file', 'folder', 'dataset'),
    vault_type = c('personal', 'general'),
    storage_class =  c('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')
  )
) {
  env <- parent.frame()
  # remove common args
  keys <- setdiff(ls(env), exclude)
  values <- mget(keys, env)

  params <- list()
  for (key in keys) {
    value <- get(key, env)
    args <- match_args[[key]]
    if (length(value)) {
      if (length(args)) {
        value <- match.arg(value, args)
      }
      params[[key]] <- value
    }
  }
  
  params
}

#' @inherit Object.retrieve
#' @inheritParams params
#' @export
object <- function(id = NULL, full_path = NULL, path = NULL,  vault_id = NULL, 
  conn = get_connection(), ...) 
{
  
  get_by("v2/objects", 
    by = list(id = id, full_path = full_path, vault_path = list(vault_id = vault_id, path = path)), 
    conn = conn, ...)
}


#' @export
object_create <- function(
  vault_id,
  filename,
  object_type,
  parent_object_id = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  mimetype = NULL,
  size = NULL,
  conn = get_connection(), 
  ...) 
{
  params <- preprocess_api_params()
  request_edp_api('POST', 'v2/objects', conn = conn, params = params, ...)
}

#' @export
object_update <- function(id,  
  filename = NULL ,
  object_type = NULL,
  parent_object_id = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  conn = get_connection(), 
  ...) 
{
  params <- preprocess_api_params()
  request_edp_api('PUT', file.path('v2/objects', id), conn = conn, params = params, ...)
}

object_delete <- function(id, conn = get_connection(), ...) {
  request_edp_api('DELETE', file.path("v2/objects", id), conn = conn, ...)
}

get_by <- function(path, by = list(), conn = NULL, ...) {
  keys <- names(by)

  # process sublists
  .is_set <- function(x) {
    if (is.list(x)) {
      # a sublist is set if all its items are set, otherwise it is an error
      nb_set <- sum(lengths(x) == 1)
      if (nb_set == 0) return(FALSE)
      .die_unless(nb_set == length(x), 'all items "%s" must be set', names(x))
      return(TRUE)
    }

    length(x) == 1
  }
  
  with_values <- sapply(by, .is_set)
  nb_set <- sum(with_values)

  .die_unless(nb_set == 1, 'you must exactly one parameter among %s', keys)

  params <- list(...)
  key <- keys[with_values]
  value <- by[[key]]
 
  if (key == 'id') {
    path <- file.path(path, value)
  } else {
    if (is.list(value)) {
      params <- value 
    } else {
      params[[key]] <- value
    }
  }

  o <- request_edp_api('GET', path, conn = conn,  params = params)
  if (key != 'id') {
    if (!length(o)) return(NULL)
    o <- o[[1]]
  }

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
delete.Object <- function(x, conn = get_connection()) {
  object_delete(x$id, conn = conn)
}

#' @export
delete.ObjectId <- function(x, conn = get_connection()) {
  object_delete(x, conn = conn)
}

#' @export
print.Object <- function(x, ...) {
  count <- x$documents_count
  if (!length(count)) count <- 0L
  msg <- sprintf('%s "%s" (%s) nb:%i user:%s accessed:%s', 
    x$object_type, x$full_path, x$mimetype, count, x$user$full_name, x$last_accessed)
  cat(msg, '\n')
}

#' @export
print.ObjectList <- function(x, ...) {
  cat('EDP List of' , length(x), 'Objects\n')

  df <- as.data.frame(x)
  df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

  cols <- c('full_path', 'user_name', 'object_type', 'last_modified')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
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

#' @export
print.User <- function(x, ...) {
  msg <- sprintf('EDP user "%s"(%s) role:%s', 
    x$full_name, x$username, x$role)
  cat(msg, '\n')
}

#' @export
fetch_vaults.User <- function(x,  conn = get_connection()) {
  vaults(user_id = x$id, conn = conn)
}

#' @export
fetch_vaults.UserId <- function(x,  conn = get_connection()) {
  vaults(user_id = x, conn = conn)
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

    cat('\n')
    df <- convert_edp_list_data_to_df(x)
    print(df)
  } else {
    cat('\n')
  }
}


#' @export
as.data.frame.edplist <- function (x,  ...) {
  convert_edp_list_data_to_df(x)
}


