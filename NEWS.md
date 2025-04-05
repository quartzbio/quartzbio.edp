# version 1.0.0

**New Features**

-   Dataset Export to parquet file format. Export the EDP Datasets into parquet file and load the data into R dataframe using `Dataset_load()` function. This function leverages `arrow::read_parquet` function.

-   Refactored login flow for EDP Shiny application to support component based authorization using the `quartzbio_shiny_auth` function.

**Improvements**

-   add GitHub workflows to run R CMD check. ([EDPDEV-2381](https://precisionformedicine.atlassian.net/browse/EDPDEV-2381))

**Bug Fixes**

-   Fixed the shiny wrapper to connect to EDP with the new connection system. Removed `createEnv` to use `connect()` in the shiny wrapper to use the new credential system. [EDPDEV-2141](https://precisionformedicine.atlassian.net/browse/EDPDEV-2141)
-   Fixed `Dataset_import()` to limit the number of records that can be imported to 5000 at a time. [EDPDEV-1862](https://precisionformedicine.atlassian.net/browse/EDPDEV-1862)
-   Fixed the error occurring when querying dataset containing list fields. Made changes to `format_df_like_model` to assign the object class correctly for list field values in dataset. [EDPDEV-911](https://precisionformedicine.atlassian.net/browse/EDPDEV-911)

# version 0.99

-   beta version of the former solvebio R package.Refactoring ot the former solvebio R package. A migration of previous functions to the new interface has started.
-   refactoring the connection functions: `autoconnect()`, `set_connection()`, `connect_with_profile()`.
-   refactoring objects interfaces: `Datasets()`, `Files()`, `Vaults()`, `Folders()`.
-   direct creation of Datasets from R data.frames.
-   `Dataset_query()` has been parallelized (see `fetch_next()`, `fetch_prev()` and `fetch_all()` functions).
-   revamp `filters()` interface.
-   New functions
    -   `Dataset()`, `Datasets()`
    -   `DatasetField()`
    -   `Dataset_create()`
    -   `Dataset_import()`
    -   `Dataset_query()`
    -   `File()`, `Files()`
    -   `File_download()`, `File_get_download_url()`
    -   `File_query()`, `File_read()`, `File_upload()`
    -   `Folder()`, `Folder_create()`, `Folders()`
    -   `Object()`, `Objects()`
    -   `Task()`, `Tasks()`
    -   `User()`
    -   `Vault()`, `Vaults()`
    -   `autoconnect()`
    -   `connect()`, `connect_with_profile()`
    -   `delete()`
    -   `fetch_next()`, `fetch_prev()`,`fetch_all()`
    -   `filters()`
    -   `fetch()`, `fetch_vaults()`
