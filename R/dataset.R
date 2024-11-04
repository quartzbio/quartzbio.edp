
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
  file_id = NULL,
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

  # creates from a File Object
  .die_if(!.empty(records) && !.empty(file_id), "records (or df) and file_id cannot both be set")
  # translate to object_id used by the endpoint
  object_id <- id(file_id)
  rm(file_id)

  params <- preprocess_api_params(exclude = c('conn', 'sync'))
  res <- request_edp_api('POST', "v2/dataset_imports", conn = conn, params = params)

  if (sync) {
    status <- Task_wait_for_completion(res$task_id, recursive = TRUE, conn = conn, ...)
    if (!status) { # timeout
      warning('got timeout while waiting for dataset import task completion: ', res$task_id)
    }
  }

  res
}

#' get_url_to_parquet
#' 
#' Function to extract url of the parquet file for the given Quartzbio EDP dataset
#' 
#' @param id The ID of a QuartzBio EDP dataset, or a Dataset object.
#' @param env (optional) Custom client environment.
#' @param ... 
#' @concept  solvebio_api
get_url_to_parquet <- function(id, env = get_connection(), ...) {
  # Get the parquet endpoint
  # path <- paste("v2/endpoint", paste(id), sep ="/")
  # tryCatch({
  #   res <- .request('POST', path=path, env=env)
  #   
  # })
  
  # Using the File download url
  parquet_url <- File_get_download_url(id)
  parquet_url
}

#' Dataset_scehma
#' 
#' Retrieves the schema of the Quartzbio EDP dataset.
#' 
#' @param id The ID of a QuartzBio EDP dataset.
#' @param env (optional) Custom client environment.
#' @concept solvebio_api
#' @export
Dataset_scehma <- function(id, env = get_connection()) {
  if(!requireNamespace("arrow", quietly = TRUE)) {
    stop("Packages \"arrow\" must be installed to use this function.")
  }
  
  # S3 presigned url for the parquet file of dataset
  if(is.null(id)) {
    stop("A dataset ID is required")
  }
  parquet_url <- get_url_to_parquet(id)
  
  # Create a Parquet file reader
  pq <- arrow::ParquetFileReader$create(parquet_url)
  dataset_scehma <-pq$GetSchema()
  dataset_scehma
}

#' Dataset_load
#' 
#' Loads large Quartzbio EDP dataset and return an R data frame containing all records.
#' 
#' @param id The ID of a QuartzBio EDP dataset.
#' @param full_path a valid dataset full path, including the account, vault and path to EDP Dataset.
#' @param env (optional) Custom client environment.
#' @param limit Limit no of records.
#' @param select_fields Fields to select in the results.
#' @param exclude_fields A list of fields to exclude in the results, as a character vector.
#' @param ... 
#' @concept  solvebio_api
#' @export
Dataset_load <- function(id, full_path = NULL, env = get_connection(), fields = NULL,
                         exclude_fields = NULL) {
  if(!requireNamespace("arrow", quietly = TRUE)) {
    stop(paste("Package", shQuote("arrow"), "must be installed to use this function."))
  }
  
  if (is.null(id) && is.null(full_path)) {
    stop("A dataset ID or full path is required.")
  }
  if (!is.null(full_path)) {
    # Retrieving dataset ID by full path
    dt <- Dataset.get_by_full_path(full_path = full_path)
    dataset_id <- dt$id
  } else {
    dataset_id <- id
  }
  # Form expressions for field selection
  if (!is.null(fields)) {
    select_expr <- dplyr::expr(all_of(fields))
  } else if (!is.null(exclude_fields)) {
    select_expr <- dplyr::expr(-all_of(exclude_fields))
  } else{
    select_expr <- NULL
  }
  parquet_url <- get_url_to_parquet(dataset_id)
  
  tryCatch({
    df <- arrow::read_parquet(parquet_url, col_select = !!select_expr)
  }, error = function(e) {
    stop(sprintf("Error in reading dataset: %s\n", e$message))
  })
  
  df
}
# hgvs <- Dataset_load("2401538393287146373")

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
  parallel = FALSE, 
  workers = 4,
  conn = get_connection(),
  ...) 
{
  dataset_id <- id(dataset_id)
  .die_unless(length(limit) == 1 && is.finite(limit), 'you must set a limit')

  # filters: may be a JSON string or a R data structure
  if (.is_nz_string(filters))
    filters <- jsonlite::fromJSON(filters, simplifyVector = FALSE)

  params  <- preprocess_api_params()
  api_path <- file.path("v2/datasets", dataset_id, 'data')

  HARDLIMIT <- 10000
  limit <- min(limit, HARDLIMIT)

  all <- params$all
  params$all <- NULL

  df <- request_edp_api('POST', api_path, params = params, parse_as_df = TRUE,  conn = conn, 
    limit = limit, offset = offset, ...)

  if (all) {
    df <- fetch_all(df, parallel = parallel, workers = workers)
  }

  if (meta) {
    tt <- system.time({
      fields <- DatasetFields(dataset_id, limit = HARDLIMIT, conn = conn, all = TRUE)
      df <- format_df_with_fields(df, fields)
    }, gcFirst = FALSE)
    msg('took %s to process the meta data.', tt[3])
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
