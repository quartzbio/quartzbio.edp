# Changelog

## version 1.0.0

**New Features**

- Multipart upload functionality. The maximum file upload size has been
  increased to 100 GB. `File_upload` automatically uses multipart upload
  for files with size larger than the multipart_threshold.

- To improve developer experience in shiny applications users can add
  verbose logs in log file by leveraging `logger` package. Users can
  create log file and set the log-level using `configure_logger` and add
  logs using `log_message` functions.

- EDP Health Check. Perform a quick check to test your EDP credentials,
  connection, user details and vaults using `edp_health_check` function.

- Dataset Export to parquet file format. Export the EDP Datasets into
  parquet file and load the data into R dataframe using
  [`Dataset_load()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_load.md)
  function. This function leverages
  [`arrow::read_parquet`](https://arrow.apache.org/docs/r/reference/read_parquet.html)
  function.

- Refactored login flow for EDP Shiny application to support component
  based authorization using the `quartzbio_shiny_auth` function.

- Add support for EDP Shortcut objects. Adds new functions: `Shortcuts`,
  `Shortcut`, `Shortcut_create`, `is_shortcut` and
  `Shortcut_get_target`.

**Improvements**

- add GitHub workflows to run R CMD check.

**Bug Fixes**

- Fixed the shiny wrapper to connect to EDP with the new connection
  system. Removed `createEnv` to use
  [`connect()`](https://quartzbio.github.io/quartzbio.edp/reference/connect.md)
  in the shiny wrapper to use the new credential system.

- Fixed
  [`Dataset_import()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_import.md)
  to limit the number of records that can be imported to 5000 at a time.

- Fixed the error occurring when querying dataset containing list
  fields. Made changes to `format_df_like_model` to assign the object
  class correctly for list field values in dataset.

## version 0.99

- beta version of the former solvebio R package.Refactoring ot the
  former solvebio R package. A migration of previous functions to the
  new interface has started.
- refactoring the connection functions:
  [`autoconnect()`](https://quartzbio.github.io/quartzbio.edp/reference/autoconnect.md),
  [`set_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/set_connection.md),
  [`connect_with_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/connect_with_profile.md).
- refactoring objects interfaces:
  [`Datasets()`](https://quartzbio.github.io/quartzbio.edp/reference/Datasets.md),
  [`Files()`](https://quartzbio.github.io/quartzbio.edp/reference/Files.md),
  [`Vaults()`](https://quartzbio.github.io/quartzbio.edp/reference/Vaults.md),
  [`Folders()`](https://quartzbio.github.io/quartzbio.edp/reference/Folders.md).
- direct creation of Datasets from R data.frames.
- [`Dataset_query()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_query.md)
  has been parallelized (see
  [`fetch_next()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_next.md),
  [`fetch_prev()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_prev.md)
  and
  [`fetch_all()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_all.md)
  functions).
- revamp
  [`filters()`](https://quartzbio.github.io/quartzbio.edp/reference/filters.md)
  interface.
- New functions
  - [`Dataset()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.md),
    [`Datasets()`](https://quartzbio.github.io/quartzbio.edp/reference/Datasets.md)
  - [`DatasetField()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.md)
  - [`Dataset_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_create.md)
  - [`Dataset_import()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_import.md)
  - [`Dataset_query()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_query.md)
  - [`File()`](https://quartzbio.github.io/quartzbio.edp/reference/File.md),
    [`Files()`](https://quartzbio.github.io/quartzbio.edp/reference/Files.md)
  - [`File_download()`](https://quartzbio.github.io/quartzbio.edp/reference/File_download.md),
    [`File_get_download_url()`](https://quartzbio.github.io/quartzbio.edp/reference/File_get_download_url.md)
  - [`File_query()`](https://quartzbio.github.io/quartzbio.edp/reference/File_query.md),
    [`File_read()`](https://quartzbio.github.io/quartzbio.edp/reference/File_read.md),
    [`File_upload()`](https://quartzbio.github.io/quartzbio.edp/reference/File_upload.md)
  - [`Folder()`](https://quartzbio.github.io/quartzbio.edp/reference/Folder.md),
    [`Folder_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Folder_create.md),
    [`Folders()`](https://quartzbio.github.io/quartzbio.edp/reference/Folders.md)
  - [`Object()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.md),
    [`Objects()`](https://quartzbio.github.io/quartzbio.edp/reference/Objects.md)
  - [`Task()`](https://quartzbio.github.io/quartzbio.edp/reference/Task.md),
    [`Tasks()`](https://quartzbio.github.io/quartzbio.edp/reference/Tasks.md)
  - [`User()`](https://quartzbio.github.io/quartzbio.edp/reference/User.md)
  - [`Vault()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.md),
    [`Vaults()`](https://quartzbio.github.io/quartzbio.edp/reference/Vaults.md)
  - [`autoconnect()`](https://quartzbio.github.io/quartzbio.edp/reference/autoconnect.md)
  - [`connect()`](https://quartzbio.github.io/quartzbio.edp/reference/connect.md),
    [`connect_with_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/connect_with_profile.md)
  - [`delete()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  - [`fetch_next()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_next.md),
    [`fetch_prev()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_prev.md),[`fetch_all()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_all.md)
  - [`filters()`](https://quartzbio.github.io/quartzbio.edp/reference/filters.md)
  - [`fetch()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md),
    [`fetch_vaults()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
