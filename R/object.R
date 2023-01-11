#' fetches a list of objects (files, folders, datasets) 
#' 
#' @inheritParams params
#' @export
Objects <- function(
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
  limit = NULL, page = NULL,
  conn = get_connection()) 
{
  params  <- preprocess_api_params()
  if (length(params$tag)) {
    params$tags <- params$tag
    params$tag <- NULL
  }

  request_edp_api('GET', "v2/objects", conn = conn, limit = limit, page = page, params = params)
}


#' fetches an object.
#' 
#' @param id    an Object ID 
#' @inheritParams params
#' @export
Object <- function(id = NULL, full_path = NULL, path = NULL,  vault_id = NULL, object_type = NULL,
  conn = get_connection()) 
{
  if (length(id)) return(request_edp_api('GET', file.path('v2/objects', id(id))))
 
  vault_id <- id(vault_id)
  fetch_by("v2/objects", 
    by = list(full_path = full_path, object_type = object_type, 
      vault_path = list(vault_id = vault_id, path = path)), 
    unique = FALSE,
    conn = conn)
}


#' creates an Object.
#' @inheritParams params
#' @return the object as as list with class Object
#' @export
Object_create <- function(
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
  conn = get_connection()) 
{
  params <- preprocess_api_params()
  request_edp_api('POST', 'v2/objects', conn = conn, params = params)
}


#' updates an Object. 
#' @inheritParams params
#' @inheritParams Object
#' @return the object as as list with class Object
#' @export
Object_update <- function(id,  
  filename = NULL ,
  object_type = NULL,
  parent_object_id = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  conn = get_connection()) 
{
  params <- preprocess_api_params()
  request_edp_api('PUT', file.path('v2/objects', id), conn = conn, params = params)
}

Object_delete <- function(id, conn = get_connection()) {
  request_edp_api('DELETE', file.path("v2/objects", id), conn = conn)
}

#' @export
print.Object <- function(x, ...) {
  count <- x$documents_count
  if (!length(count)) count <- 0L
  msg <- .safe_sprintf('%s "%s" (%s) nb:%i user:%s accessed:%s', 
    x$object_type, x$full_path, x$mimetype, count, x$user$full_name, x$last_accessed)
  cat(msg, '\n')
}

#' @export
print.ObjectList <- function(x, ...) {
  cat('EDP List of' , length(x), 'Objects\n')

  df <- as.data.frame(x)
  df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

  cols <- c('path', 'object_type', 'vault_name',  'user_name', 'object_type', 'last_modified')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

#' @export
fetch.ObjectId <- function(x,  conn = get_connection()) {
  Object(id = x, conn = conn)
}


#### Object methods
#' @export
delete.Object <- function(x, conn = get_connection()) {
  Object_delete(x$id, conn = conn)
}

#' @export
delete.ObjectId <- function(x, conn = get_connection()) {
  Object_delete(x, conn = conn)
}
