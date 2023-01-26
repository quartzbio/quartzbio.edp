
#' fetches a list of datasets.
#' @inheritParams params
#' @export
Datasets <- function(
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
  lst <- Objects(vault_id = vault_id, vault_name = vault_name, vault_full_path = vault_full_path, 
    filename = filename, path = path, object_type = 'dataset', depth = depth, 
    query = query, regex = regex, glob = glob, ancestor_id = ancestor_id, 
    min_distance = min_distance, tag = tag, storage_class = storage_class, 
    conn = conn, limit = limit, page = page)
  class(lst) <- c('DatasetList', class(lst))

  lst
}

#' creates a new Dataset.
#' @export
Dataset_create <- function(
  vault_id,
  name,
  fields = NULL,
  parent_object_id = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  capacity = NULL,
  conn = get_connection()) 
{
  obj <- Object_create(vault_id, filename, 
    object_type = 'dataset', 
    parent_object_id = fo$id,
    size = size, 
    conn = conn)
}



#' @export
print.Dataset <- function(x, ...) {
  count <- x$documents_count
  if (!length(count)) count <- 'NA'
  msg <- .safe_sprintf('Dataset "%s", %s documents, updated at:%s', 
    x$vault_object_path, count, x$updated_at)
  cat(msg, '\n')
}

#' @export
print.DatasetList <- function(x, ...) {
  cat('EDP List of' , length(x), 'Datasets\n')

  df <- as.data.frame(x)
  df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

  cols <- c('path',  'documents_count', 'vault_name',  'user_name', 'last_modified')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

#' @export
fetch.DatasetId <- function(x,  conn = get_connection()) {
  Dataset(x, conn = conn)
}

#' @export
fetch.UserId <- function(x,  conn = get_connection()) {
  User(x, conn = conn)
}
