# Package index

## EDP connections

Set, get manage connections to EDP using profiles or environments
variables

- [`autoconnect()`](https://quartzbio.github.io/quartzbio.edp/reference/autoconnect.md)
  : tries to connect, using environment variables or the default profile
- [`connect()`](https://quartzbio.github.io/quartzbio.edp/reference/connect.md)
  : connect to the QuartzBio EDP API and return the connection
- [`connect_with_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/connect_with_profile.md)
  : connect to the QuartzBio EDP API using a saved profile
- [`get_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/get_connection.md)
  : get the default connection if any
- [`read_connection_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/read_connection_profile.md)
  : read a connection profile
- [`save_connection_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/save_connection_profile.md)
  : save a connection profile
- [`set_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/set_connection.md)
  : set the default connection
- [`test_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/test_connection.md)
  : test a connection
- [`params`](https://quartzbio.github.io/quartzbio.edp/reference/params.md)
  : shared roxygen params

## Vaults, Files, Folders

Vaults, Files, Folders management [Vaults and
Objects](https://quartzbio.github.io/quartzbio.edp/articles/vaults_n_objects.md)

- [`Vault_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault_create.md)
  : creates a new EDP vault or updates an existing one.
- [`Vault_update()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault_update.md)
  : updates a vault
- [`Folder_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Folder_create.md)
  : creates a folder.
- [`File_download()`](https://quartzbio.github.io/quartzbio.edp/reference/File_download.md)
  : utility function that downloads an EDP File into a local file
- [`File_get_download_url()`](https://quartzbio.github.io/quartzbio.edp/reference/File_get_download_url.md)
  : fetches the download URL of a file.
- [`File_query()`](https://quartzbio.github.io/quartzbio.edp/reference/File_query.md)
  : queries the content of a file.
- [`File_read()`](https://quartzbio.github.io/quartzbio.edp/reference/File_read.md)
  : convenience function to download a file into memory, just a wrapper
  over File_download()
- [`File_upload()`](https://quartzbio.github.io/quartzbio.edp/reference/File_upload.md)
  : uploads a file Upload a file to a QuartzBio vault. Automatically
  uses multipart upload for files larger than the multipart_threshold.
  multipart_threshold (int): File size threshold for multipart upload
  (default: 64MB) multipart_chunksize (int): Size of each upload part
  (default: 64MB)

## Datasets

- [`Dataset_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_create.md)
  : creates a new Dataset.
- [`Dataset_import()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_import.md)
  : imports data into an existing dataset
- [`Dataset_load()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_load.md)
  : Dataset_load
- [`Dataset_query()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_query.md)
  : queries data into a dataset.
- [`Dataset_schema()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_schema.md)
  : Get dataset schema

## Fetching, Querying and Filtering

- [`fetch_all()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_all.md)
  : fetch all the pages for a possibly incomplete paginated API result
- [`fetch_next()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_next.md)
  : fetch the next page of data if any
- [`fetch_prev()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_prev.md)
  : fetch the previous page of data if any
- [`delete()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  [`fetch()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  [`fetch_vaults()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  : deletes an object from EDP
- [`Dataset_query()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_query.md)
  : queries data into a dataset.
- [`File_query()`](https://quartzbio.github.io/quartzbio.edp/reference/File_query.md)
  : queries the content of a file.
- [`filters()`](https://quartzbio.github.io/quartzbio.edp/reference/filters.md)
  : parses the maths-like syntax of filters.

## All Functions

- [`Dataset()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.md)
  : fetches a dataset.
- [`DatasetField()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.md)
  : fetches a field metadata of a dataset by ID or (datasetid,
  field_name)
- [`DatasetField_create()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField_create.md)
  : creates a new Dataset Field.
- [`DatasetField_update()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField_update.md)
  : updates an existing Dataset Field.
- [`DatasetFields()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetFields.md)
  : fetches the fields of a dataset.
- [`Dataset_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_create.md)
  : creates a new Dataset.
- [`Dataset_import()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_import.md)
  : imports data into an existing dataset
- [`Dataset_query()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_query.md)
  : queries data into a dataset.
- [`Datasets()`](https://quartzbio.github.io/quartzbio.edp/reference/Datasets.md)
  : fetches a list of datasets.
- [`File()`](https://quartzbio.github.io/quartzbio.edp/reference/File.md)
  : fetches a file by id, full_path or (vault_id, path)
- [`File_download()`](https://quartzbio.github.io/quartzbio.edp/reference/File_download.md)
  : utility function that downloads an EDP File into a local file
- [`File_get_download_url()`](https://quartzbio.github.io/quartzbio.edp/reference/File_get_download_url.md)
  : fetches the download URL of a file.
- [`File_query()`](https://quartzbio.github.io/quartzbio.edp/reference/File_query.md)
  : queries the content of a file.
- [`File_read()`](https://quartzbio.github.io/quartzbio.edp/reference/File_read.md)
  : convenience function to download a file into memory, just a wrapper
  over File_download()
- [`File_upload()`](https://quartzbio.github.io/quartzbio.edp/reference/File_upload.md)
  : uploads a file Upload a file to a QuartzBio vault. Automatically
  uses multipart upload for files larger than the multipart_threshold.
  multipart_threshold (int): File size threshold for multipart upload
  (default: 64MB) multipart_chunksize (int): Size of each upload part
  (default: 64MB)
- [`Files()`](https://quartzbio.github.io/quartzbio.edp/reference/Files.md)
  : fetches a list of files.
- [`Folder()`](https://quartzbio.github.io/quartzbio.edp/reference/Folder.md)
  : fetches a folder by id, full_path or (vault_id, path)
- [`Folder_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Folder_create.md)
  : creates a folder.
- [`Folders()`](https://quartzbio.github.io/quartzbio.edp/reference/Folders.md)
  : fetches a list of folders.
- [`Multi_part_file_upload()`](https://quartzbio.github.io/quartzbio.edp/reference/Multi_part_file_upload.md)
  : Function to support multi-part upload for files larger than
  multipart_threshold.
- [`Object()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.md)
  : fetches an object.
- [`Object_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Object_create.md)
  : creates an Object.
- [`Object_update()`](https://quartzbio.github.io/quartzbio.edp/reference/Object_update.md)
  : updates an Object.
- [`Objects()`](https://quartzbio.github.io/quartzbio.edp/reference/Objects.md)
  : fetches a list of objects (files, folders, datasets)
- [`Task()`](https://quartzbio.github.io/quartzbio.edp/reference/Task.md)
  : fetches a task.
- [`Task_wait_for_completion()`](https://quartzbio.github.io/quartzbio.edp/reference/Task_wait_for_completion.md)
  : Waits for a task to be completed (or failed).
- [`Tasks()`](https://quartzbio.github.io/quartzbio.edp/reference/Tasks.md)
  : fetches a list of tasks.
- [`User()`](https://quartzbio.github.io/quartzbio.edp/reference/User.md)
  : fetches user information.
- [`Vault()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.md)
  : fetches a vault
- [`Vault_create()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault_create.md)
  : creates a new EDP vault or updates an existing one.
- [`Vault_update()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault_update.md)
  : updates a vault
- [`Vaults()`](https://quartzbio.github.io/quartzbio.edp/reference/Vaults.md)
  : fetches a list of vaults
- [`autoconnect()`](https://quartzbio.github.io/quartzbio.edp/reference/autoconnect.md)
  : tries to connect, using environment variables or the default profile
- [`configure_logger()`](https://quartzbio.github.io/quartzbio.edp/reference/configure_logger.md)
  : Configure log file and set the log-level
- [`connect()`](https://quartzbio.github.io/quartzbio.edp/reference/connect.md)
  : connect to the QuartzBio EDP API and return the connection
- [`connect_with_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/connect_with_profile.md)
  : connect to the QuartzBio EDP API using a saved profile
- [`create_model_df_from_fields()`](https://quartzbio.github.io/quartzbio.edp/reference/create_model_df_from_fields.md)
  : create a model data frame from a list of column names and some meta
  data fields.
- [`dataset_export_to_parquet()`](https://quartzbio.github.io/quartzbio.edp/reference/dataset_export_to_parquet.md)
  : Initiate a Dataset export to parquet
- [`edp_health_check()`](https://quartzbio.github.io/quartzbio.edp/reference/edp_health_check.md)
  : edp_health_check
- [`fetch_all()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_all.md)
  : fetch all the pages for a possibly incomplete paginated API result
- [`fetch_next()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_next.md)
  : fetch the next page of data if any
- [`fetch_prev()`](https://quartzbio.github.io/quartzbio.edp/reference/fetch_prev.md)
  : fetch the previous page of data if any
- [`filters()`](https://quartzbio.github.io/quartzbio.edp/reference/filters.md)
  : parses the maths-like syntax of filters.
- [`format_df_like_model()`](https://quartzbio.github.io/quartzbio.edp/reference/format_df_like_model.md)
  : Format a data frame like the model data frame
- [`delete()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  [`fetch()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  [`fetch_vaults()`](https://quartzbio.github.io/quartzbio.edp/reference/generics.md)
  : deletes an object from EDP
- [`get_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/get_connection.md)
  : get the default connection if any
- [`log_message()`](https://quartzbio.github.io/quartzbio.edp/reference/log_message.md)
  : Record a log message with the given log level
- [`old_params`](https://quartzbio.github.io/quartzbio.edp/reference/old_params.md)
  : shared old roxygen params
- [`params`](https://quartzbio.github.io/quartzbio.edp/reference/params.md)
  : shared roxygen params
- [`quartzbio_shiny_auth()`](https://quartzbio.github.io/quartzbio.edp/reference/quartzbio_shiny_auth.md)
  : New function for EDP auth of shiny app. Returns the updated session
  with EDP connection to be used in shiny app
- [`read_connection_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/read_connection_profile.md)
  : read a connection profile
- [`save_connection_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/save_connection_profile.md)
  : save a connection profile
- [`set_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/set_connection.md)
  : set the default connection
- [`test_connection()`](https://quartzbio.github.io/quartzbio.edp/reference/test_connection.md)
  : test a connection

## Legacy former solvebio API

Former solvebio api functions. Compatible with the new connection
functions.

- [`Annotator.annotate()`](https://quartzbio.github.io/quartzbio.edp/reference/Annotator.annotate.md)
  : Annotate a data table/frame with additional fields.
- [`Application.all()`](https://quartzbio.github.io/quartzbio.edp/reference/Application.all.md)
  : Retrieve the metadata about all application on QuartzBio EDP
  available to the current user.
- [`Application.create()`](https://quartzbio.github.io/quartzbio.edp/reference/Application.create.md)
  : Application.create
- [`Application.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/Application.delete.md)
  : Application.delete
- [`Application.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/Application.retrieve.md)
  : Retrieve the metadata about a specific application QuartzBio EDP.
- [`Application.update()`](https://quartzbio.github.io/quartzbio.edp/reference/Application.update.md)
  : Application.update
- [`Beacon.all()`](https://quartzbio.github.io/quartzbio.edp/reference/Beacon.all.md)
  : Beacon.all
- [`Beacon.create()`](https://quartzbio.github.io/quartzbio.edp/reference/Beacon.create.md)
  : Beacon.create
- [`Beacon.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/Beacon.delete.md)
  : Beacon.delete
- [`Beacon.query()`](https://quartzbio.github.io/quartzbio.edp/reference/Beacon.query.md)
  : Beacon.query
- [`Beacon.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/Beacon.retrieve.md)
  : Beacon.retrieve
- [`Beacon.update()`](https://quartzbio.github.io/quartzbio.edp/reference/Beacon.update.md)
  : Beacon.update
- [`BeaconSet.all()`](https://quartzbio.github.io/quartzbio.edp/reference/BeaconSet.all.md)
  : BeaconSet.all
- [`BeaconSet.create()`](https://quartzbio.github.io/quartzbio.edp/reference/BeaconSet.create.md)
  : BeaconSet.create
- [`BeaconSet.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/BeaconSet.delete.md)
  : BeaconSet.delete
- [`BeaconSet.query()`](https://quartzbio.github.io/quartzbio.edp/reference/BeaconSet.query.md)
  : BeaconSet.query
- [`BeaconSet.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/BeaconSet.retrieve.md)
  : BeaconSet.retrieve
- [`BeaconSet.update()`](https://quartzbio.github.io/quartzbio.edp/reference/BeaconSet.update.md)
  : BeaconSet.update
- [`Dataset.activity()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.activity.md)
  : Dataset.activity
- [`Dataset.all()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.all.md)
  : Retrieves the metadata about datasets on QuartzBio EDP.
- [`Dataset.count()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.count.md)
  : Dataset.count
- [`Dataset.create()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.create.md)
  : Dataset.create
- [`Dataset.data()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.data.md)
  : Dataset.data
- [`Dataset.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.delete.md)
  : Dataset.delete
- [`Dataset.disable_global_beacon()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.disable_global_beacon.md)
  : Dataset.disable_global_beacon
- [`Dataset.enable_global_beacon()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.enable_global_beacon.md)
  : Dataset.enable_global_beacon
- [`Dataset.facets()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.facets.md)
  : Dataset.facets
- [`Dataset.fields()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.fields.md)
  : Dataset.fields
- [`Dataset.get_by_full_path()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.get_by_full_path.md)
  : Dataset.get_by_full_path
- [`Dataset.get_global_beacon_status()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.get_global_beacon_status.md)
  : Dataset.get_global_beacon_status
- [`Dataset.get_or_create_by_full_path()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.get_or_create_by_full_path.md)
  : Dataset.get_or_create_by_full_path
- [`Dataset.query()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.query.md)
  : Dataset.query
- [`Dataset.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.retrieve.md)
  : Dataset.retrieve
- [`Dataset.template()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.template.md)
  : Dataset.template
- [`Dataset.update()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset.update.md)
  : Dataset.update
- [`DatasetCommit.all()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetCommit.all.md)
  : DatasetCommit.all
- [`DatasetCommit.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetCommit.delete.md)
  : DatasetCommit.delete
- [`DatasetCommit.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetCommit.retrieve.md)
  : DatasetCommit.retrieve
- [`DatasetExport.all()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetExport.all.md)
  : DatasetExport.all
- [`DatasetExport.create()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetExport.create.md)
  : DatasetExport.create
- [`DatasetExport.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetExport.delete.md)
  : DatasetExport.delete
- [`DatasetExport.get_download_url()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetExport.get_download_url.md)
  : DatasetExport.get_download_url
- [`DatasetExport.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetExport.retrieve.md)
  : DatasetExport.retrieve
- [`DatasetField.all()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.all.md)
  : DatasetField.all
- [`DatasetField.create()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.create.md)
  : DatasetField.create
- [`DatasetField.facets()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.facets.md)
  : DatasetField.facets
- [`DatasetField.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.retrieve.md)
  : DatasetField.retrieve
- [`DatasetField.update()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetField.update.md)
  : DatasetField.update
- [`DatasetImport.all()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetImport.all.md)
  : DatasetImport.all
- [`DatasetImport.create()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetImport.create.md)
  : DatasetImport.create
- [`DatasetImport.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetImport.delete.md)
  : DatasetImport.delete
- [`DatasetImport.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetImport.retrieve.md)
  : DatasetImport.retrieve
- [`DatasetMigration.all()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetMigration.all.md)
  : DatasetMigration.all
- [`DatasetMigration.create()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetMigration.create.md)
  : DatasetMigration.create
- [`DatasetMigration.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetMigration.delete.md)
  : DatasetMigration.delete
- [`DatasetMigration.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetMigration.retrieve.md)
  : DatasetMigration.retrieve
- [`DatasetTemplate.all()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetTemplate.all.md)
  : DatasetTemplate.all
- [`DatasetTemplate.create()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetTemplate.create.md)
  : DatasetTemplate.create
- [`DatasetTemplate.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetTemplate.delete.md)
  : DatasetTemplate.delete
- [`DatasetTemplate.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetTemplate.retrieve.md)
  : DatasetTemplate.retrieve
- [`DatasetTemplate.update()`](https://quartzbio.github.io/quartzbio.edp/reference/DatasetTemplate.update.md)
  : DatasetTemplate.update
- [`Dataset_load()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_load.md)
  : Dataset_load
- [`Dataset_schema()`](https://quartzbio.github.io/quartzbio.edp/reference/Dataset_schema.md)
  : Get dataset schema
- [`Expression.evaluate()`](https://quartzbio.github.io/quartzbio.edp/reference/Expression.evaluate.md)
  : Evaluate a QuartzBio EDP expression.
- [`GlobalSearch.facets()`](https://quartzbio.github.io/quartzbio.edp/reference/GlobalSearch.facets.md)
  : GlobalSearch.facets
- [`GlobalSearch.request()`](https://quartzbio.github.io/quartzbio.edp/reference/GlobalSearch.request.md)
  : GlobalSearch.request
- [`GlobalSearch.search()`](https://quartzbio.github.io/quartzbio.edp/reference/GlobalSearch.search.md)
  : GlobalSearch.search
- [`GlobalSearch.subjects()`](https://quartzbio.github.io/quartzbio.edp/reference/GlobalSearch.subjects.md)
  : GlobalSearch.subjects
- [`GlobalSearch.subjects_count()`](https://quartzbio.github.io/quartzbio.edp/reference/GlobalSearch.subjects_count.md)
  : GlobalSearch.subjects_count
- [`Object.all()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.all.md)
  : Retrieves the metadata about all objects on EDP accessible to the
  current user.
- [`Object.create()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.create.md)
  : Object.create
- [`Object.data()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.data.md)
  : Object.data
- [`Object.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.delete.md)
  : Object.delete
- [`Object.disable_global_beacon()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.disable_global_beacon.md)
  : Object.disable_global_beacon
- [`Object.enable_global_beacon()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.enable_global_beacon.md)
  : Object.enable_global_beacon
- [`Object.fields()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.fields.md)
  : Object.fields
- [`Object.get_by_full_path()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.get_by_full_path.md)
  : Object.get_by_full_path
- [`Object.get_by_path()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.get_by_path.md)
  : Object.get_by_path
- [`Object.get_download_url()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.get_download_url.md)
  : Object.get_download_url
- [`Object.get_global_beacon_status()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.get_global_beacon_status.md)
  : Object.get_global_beacon_status
- [`Object.get_or_upload_file()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.get_or_upload_file.md)
  : Object.get_or_upload_file
- [`Object.query()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.query.md)
  : Object.query
- [`Object.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.retrieve.md)
  : Object.retrieve
- [`Object.update()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.update.md)
  : Object.update
- [`Object.upload_file()`](https://quartzbio.github.io/quartzbio.edp/reference/Object.upload_file.md)
  : Object.upload_file
- [`SavedQuery.all()`](https://quartzbio.github.io/quartzbio.edp/reference/SavedQuery.all.md)
  : SavedQuery.all
- [`SavedQuery.create()`](https://quartzbio.github.io/quartzbio.edp/reference/SavedQuery.create.md)
  : SavedQuery.create
- [`SavedQuery.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/SavedQuery.delete.md)
  : SavedQuery.delete
- [`SavedQuery.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/SavedQuery.retrieve.md)
  : SavedQuery.retrieve
- [`SavedQuery.update()`](https://quartzbio.github.io/quartzbio.edp/reference/SavedQuery.update.md)
  : SavedQuery.update
- [`Task.all()`](https://quartzbio.github.io/quartzbio.edp/reference/Task.all.md)
  : Task.all
- [`Task.follow()`](https://quartzbio.github.io/quartzbio.edp/reference/Task.follow.md)
  : Task.follow
- [`Task.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/Task.retrieve.md)
  : Task.retrieve
- [`User.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/User.retrieve.md)
  : Retrieves information about the current user
- [`Vault.all()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.all.md)
  : Vault.all
- [`Vault.create()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.create.md)
  : Vault.create
- [`Vault.create_dataset()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.create_dataset.md)
  : Vault.create_dataset
- [`Vault.create_folder()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.create_folder.md)
  : Vault.create_folder
- [`Vault.datasets()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.datasets.md)
  : Vault.datasets
- [`Vault.delete()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.delete.md)
  : Vault.delete
- [`Vault.files()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.files.md)
  : Vault.files
- [`Vault.folders()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.folders.md)
  : Vault.folders
- [`Vault.get_by_full_path()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.get_by_full_path.md)
  : Vault.get_by_full_path
- [`Vault.get_or_create_by_full_path()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.get_or_create_by_full_path.md)
  : Vault.get_or_create_by_full_path
- [`Vault.get_personal_vault()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.get_personal_vault.md)
  : Vault.get_personal_vault
- [`Vault.objects()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.objects.md)
  : Vault.objects
- [`Vault.retrieve()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.retrieve.md)
  : Vault.retrieve
- [`Vault.search()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.search.md)
  : Vault.search
- [`Vault.update()`](https://quartzbio.github.io/quartzbio.edp/reference/Vault.update.md)
  : Vault.update
- [`login()`](https://quartzbio.github.io/quartzbio.edp/reference/login.md)
  : login
- [`protectedServer()`](https://quartzbio.github.io/quartzbio.edp/reference/protectedServer.md)
  : protectedServer
- [`protectedServerJS()`](https://quartzbio.github.io/quartzbio.edp/reference/protectedServerJS.md)
  : protectedServerUI
