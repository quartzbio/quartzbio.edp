
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
