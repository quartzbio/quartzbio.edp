
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


#' fetches a dataset.
#' @inheritParams params
#' @export
Dataset <- function(dataset_id = NULL, full_path = NULL, path = NULL, vault_id = NULL, 
  conn = get_connection()) 
{
  Object(object_type = 'dataset', id = dataset_id, full_path = full_path, path = path, vault_id = vault_id, 
    conn = conn)
}

#' creates a new Dataset.
#' 
#' @inherit params
#' @export
Dataset_create <- function(
  vault_id,
  vault_path,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  capacity = NULL,
  conn = get_connection()) 
{
  File_create(vault_id, vault_path, 
    object_type = 'dataset', 
    description = description,
    metadata = metadata,
    tags = tags,
    storage_class = storage_class,
    capacity = capacity,
    conn = conn)
}


# TODO: try NA, NULL, ""

#' imports data into an existing dataset
#' @inheritParams params
#' @param df    The data to import as a data.frame
#' @param ... passed to [Task_wait_for_completion()]
#' @export
Dataset_import <- function(
  dataset_id,
  commit_mode = NULL,
  records = NULL,
  df = NULL,
  target_fields = infer_fields_from_df(df),
  sync = FALSE,
  conn = get_connection(),
  ...)
{
  dataset_id <- id(dataset_id)

  if (length(df)) {
    records <- split(df, seq(nrow(df)))
    records <- lapply(records, as.list)
    names(records) <- NULL

    # evaluate fields before removing df
    force(target_fields)
    rm(df)
  }

  params  <- preprocess_api_params(exclude = c('conn', 'sync'))
  res <- request_edp_api('POST', "v2/dataset_imports", conn = conn, params = params)

  if (sync) {
    status <- Task_wait_for_completion(res$task_id, recursive = TRUE, conn = conn, ...)
 
    if (!status) { # timeout
      warning('got timeout while waiting for dataset import task completion: ', res$task_id)
    }
  }

  res
}

#' queries data into a dataset.
#' @inheritParams params
#' @param meta    whether to retrieve fields meta data information to properly format, reorder
#'                and rename the data frame
#' @export
Dataset_query <- function(
  dataset_id,
  filters = NULL,
  facets = NULL,
  fields = NULL,
  exclude_fields = c('_id', '_commit'),
  ordering = NULL,
  query = NULL,
  limit = 10000, offset = NULL, all = FALSE,
  meta = TRUE,
  conn = get_connection(),
  ...) 
{
  dataset_id <- id(dataset_id)
  # filters: may be a JSON string or a R data structure
  if (.is_nz_string(filters))
    filters <- jsonlite::fromJSON(filters, simplifyVector = FALSE)

  params  <- preprocess_api_params()
  all <- params$all
  params$all <- NULL

  df <- request_edp_api('POST', file.path("v2/datasets", dataset_id, 'data'), params = params, 
      parse_as_df = TRUE, conn = conn, limit = limit, offset = offset, ...)
  if (all) df <- fetch_all(df)

  if (meta) {
    fields <- DatasetFields(dataset_id, limit = 10000, conn = conn, all = TRUE)
    df <- format_df_with_fields(df, fields)
  }

  df
}

###
### utilities



### 
### DatasetList methods 

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

