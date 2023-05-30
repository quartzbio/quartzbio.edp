# version 0.99

* beta version of the former solvebio R package.Refactoring ot the former solvebio R package.
A migration of previous functions to the new interface has started.
* refactoring the connection functions: `autoconnect()`, `set_connection()`, `connect_with_profile()`.
* refactoring objects interfaces: `Datasets()`, `Files()`, `Vaults()`, `Folders()`.
* direct creation of Datasets from R data.frames.
* `Dataset_query()` has been parallelized (see `fetch_next()`, `fetch_prev()` and `fetch_all()` functions). 
* revamp `filters()` interface.
* New functions
    * `Dataset()`, `Datasets()`
    * `DatasetField()`
    * `Dataset_create()`
    * `Dataset_import()`
    * `Dataset_query()`
    * `File()`, `Files()`
    * `File_download()`, `File_get_download_url()`
    * `File_query()`, `File_read()`, `File_upload()`
    * `Folder()`, `Folder_create()`, `Folders()` 
    * `Object()`, `Objects()`
    * `Task()`, `Tasks()`
    * `User()`
    * `Vault()`, `Vaults()`
    * `autoconnect()`
    * `connect()`, `connect_with_profile()`
    * `delete()`
    * `fetch_next()`, `fetch_prev()`,`fetch_all()`
    * `filters()`
    * `fetch()`, `fetch_vaults()` 
