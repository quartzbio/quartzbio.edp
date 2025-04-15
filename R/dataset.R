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
    conn = get_connection()) {
  lst <- Objects(
    vault_id = vault_id, vault_name = vault_name, vault_full_path = vault_full_path,
    filename = filename, path = path, object_type = "dataset", depth = depth,
    query = query, regex = regex, glob = glob, ancestor_id = ancestor_id,
    min_distance = min_distance, tag = tag, storage_class = storage_class,
    conn = conn, limit = limit, page = page
  )
  class(lst) <- c("DatasetList", class(lst))

  lst
}


#' fetches a dataset.
#' @inheritParams params
#' @export
Dataset <- function(
    dataset_id = NULL, full_path = NULL, path = NULL, vault_id = NULL,
    conn = get_connection()) {
  Object(
    object_type = "dataset", id = dataset_id, full_path = full_path, path = path, vault_id = vault_id,
    conn = conn
  )
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
    conn = get_connection()) {
  File_create(vault_id, vault_path,
    object_type = "dataset",
    description = description,
    metadata = metadata,
    tags = tags,
    storage_class = storage_class,
    capacity = capacity,
    conn = conn
  )
}

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
    ...) {
  dataset_id <- id(dataset_id)
  # Allow import of records/data.frame up-to 5k
  max_records <- 5000

  if (length(df)) {
    .die_if(
      nrow(df) > max_records,
      paste("The maximum number of rows in dataframe that can be imported is", max_records)
    )
    records <- split(df, seq(nrow(df)))
    records <- lapply(records, as.list)
    names(records) <- NULL

    # evaluate fields before removing df
    force(target_fields)
    rm(df)
  }
  .die_if(
    !.empty(records) && length(records) > max_records,
    paste("The maximum number of records that can be imported is ", max_records)
  )

  # creates from a File Object
  .die_if(!.empty(records) && !.empty(file_id), "records (or df) and file_id cannot both be set")
  # translate to object_id used by the endpoint
  object_id <- id(file_id)
  rm(file_id)

  params <- preprocess_api_params(exclude = c("conn", "sync"))
  params <- c(params, list(...))

  res <- request_edp_api("POST", "v2/dataset_imports", conn = conn, params = params)

  if (sync) {
    status <- Task_wait_for_completion(res$task_id, recursive = TRUE, conn = conn, ...)
    if (!status) { # timeout
      warning("got timeout while waiting for dataset import task completion: ", res$task_id)
    }
  }

  res
}

#' Initiate a Dataset export to parquet
#'
#' Create a dataset export to parquet file and return the URL to export file
#'
#' @param id (character) The ID of a QuartzBio EDP dataset, or a Dataset object.
#' @param full_path (character) a valid dataset full path, including the account, vault and path to EDP Dataset.
#' @param conn (optional) Custom client environment.
#' @return URL to the parquet file for the given EDP dataset. If there is an
#' failure, an error will be raised.
#' @concept  solvebio_api
dataset_export_to_parquet <- function(id = NULL, full_path = NULL, conn = get_connection()) {
  # Retrieve the dataset ID
  if (is.null(id) && !is.null(full_path)) {
    # Retrieving dataset ID by full path
    dt <- Dataset.get_by_full_path(full_path = full_path)
    id <- dt$id
  }

  # Export dataset in parquet format
  export <- DatasetExport.create(
    id,
    format = "parquet",
    params = NULL,
    send_email_on_completion = FALSE,
    follow = TRUE
  )

  # Wait for the download URL to be generated once task completes
  Sys.sleep(1)
  parquet_url <- DatasetExport.get_download_url(export$id)
  parquet_url
}

#' Get dataset schema
#'
#' Retrieves the schema of the Quartzbio EDP dataset.
#'
#' @param id (character) The ID of a QuartzBio EDP dataset.
#' @param full_path (character) a valid dataset full path, including the account, vault and path to EDP Dataset.
#' @param parquet_path (character) provide a parquet file/ URI connection
#' @return A Schema object containing Fields, which maps to the data types.
#' @concept quartzbio_api
#' @export
Dataset_schema <- function(id = NULL, full_path = NULL, parquet_path = NULL) {
  # check for arguments
  all_null <- all(sapply(c(id, full_path, parquet_path), is.null))

  if (all_null) {
    stop("A dataset ID or full path is required")
  }

  if (!is.null(parquet_path)) {
    parquet_url <- parquet_path
  } else {
    # initiate a parquet export
    parquet_url <- dataset_export_to_parquet(id = id, full_path = full_path)
  }


  # Create a Parquet file reader
  pq <- arrow::ParquetFileReader$create(parquet_url)
  dataset_schema <- pq$GetSchema()
  dataset_schema
}

#' Dataset_load
#'
#' Loads large Quartzbio EDP dataset and returns an R data frame containing all records.
#'
#' @param id (character) The ID of a QuartzBio EDP dataset.
#' @param full_path (character) a valid dataset full path, including the account, vault and path to EDP Dataset.
#' @param get_schema (boolean) Retrieves the schema of the Quartzbio EDP dataset loaded. Default value: FALSE
#' @param filter_expr (character) A arrow Expression to filter the scanned rows by, or (default) to keep all rows. Check [arrow::Scanner()]
#' @inheritDotParams arrow::read_parquet col_select as_data_frame
#' @concept  quartzbio_api
#' @return A `tibble` which is the default, or an Arrow Table otherwise. If the `get_schema` parameter is set to `TRUE`,
#' the function returns a list containing both the `tibble` and its schema.
#' @export
Dataset_load <- function(id = NULL, full_path = NULL, get_schema = FALSE, filter_expr = NULL, ...) {
  if (is.null(id) && is.null(full_path)) {
    stop("A dataset ID or full path is required.")
  }

  parquet_url <- dataset_export_to_parquet(id = id, full_path = full_path)
  #parquet_url <- full_path

  tryCatch(
    {
      df <- arrow::read_parquet(parquet_url, ...)
    },
    error = function(e) {
      stop(sprintf("Error in reading dataset: %s\n", e$message))
    }
  )

  if (!is.null(filter_expr)) {
    df_scan <- arrow::Scanner$create(df, filter = filter_expr, ...)
    df <- as.data.frame(df_scan$ToTable())

  }

  if (get_schema) {
    schema <- Dataset_schema(parquet_path = parquet_url)
    return(list(df = df, schema = schema))
  }

  df
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
    exclude_fields = c("_id", "_commit"),
    ordering = NULL,
    query = NULL,
    limit = 10000, offset = NULL, all = FALSE,
    meta = TRUE,
    parallel = FALSE,
    workers = 4,
    conn = get_connection(),
    ...) {
  dataset_id <- id(dataset_id)
  .die_unless(length(limit) == 1 && is.finite(limit), "you must set a limit")

  # filters: may be a JSON string or a R data structure
  if (.is_nz_string(filters)) {
    filters <- jsonlite::fromJSON(filters, simplifyVector = FALSE)
  }

  params <- preprocess_api_params()
  api_path <- file.path("v2/datasets", dataset_id, "data")

  HARDLIMIT <- 10000
  limit <- min(limit, HARDLIMIT)

  all <- params$all
  params$all <- NULL

  df <- request_edp_api("POST", api_path,
    params = params, parse_as_df = TRUE, conn = conn,
    limit = limit, offset = offset, ...
  )

  if (all) {
    df <- fetch_all(df, parallel = parallel, workers = workers)
  }

  if (meta) {
    tt <- system.time(
      {
        fields <- DatasetFields(dataset_id, limit = HARDLIMIT, conn = conn, all = TRUE)
        df <- format_df_with_fields(df, fields)
      },
      gcFirst = FALSE
    )
    msg("took %s to process the meta data.", tt[3])
  }

  df
}



###
### utilities



###
### DatasetList methods

#' @export
print.DatasetList <- function(x, ...) {
  cat("EDP List of", length(x), "Datasets\n")

  df <- as.data.frame(x)
  df$user_name <- sapply(df$user, getElement, "full_name", USE.NAMES = FALSE)

  cols <- c("path", "documents_count", "vault_name", "user_name", "last_modified")
  cols <- intersect(cols, names(df))
  df <- df[cols]

  print(df)
}

#' @export
fetch.DatasetId <- function(x, conn = get_connection()) {
  Dataset(x, conn = conn)
}
