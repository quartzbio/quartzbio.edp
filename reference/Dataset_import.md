# imports data into an existing dataset

imports data into an existing dataset

## Usage

``` r
Dataset_import(
  dataset_id,
  commit_mode = NULL,
  records = NULL,
  df = NULL,
  file_id = NULL,
  target_fields = infer_fields_from_df(df),
  sync = FALSE,
  conn = get_connection(),
  ...
)
```

## Arguments

- dataset_id:

  a Dataset ID as a string

- commit_mode:

  There are four commit modes that can be selected depending on the
  scenario: append (default), overwrite, upsert, and delete.

- records:

  The data to annotate as a data frame.

- df:

  The data to import as a data.frame

- file_id:

  a file Object ID.

- target_fields:

  A list of valid dataset fields to create or override in the import, as
  a character vector.

- sync:

  whether to proceed in synchronous mode, i.e to wait for all sub tasks
  to finish before returning.

- conn:

  a EDP connection object (as a named list or environment)

- ...:

  passed to
  [`Task_wait_for_completion()`](https://quartzbio.github.io/quartzbio.edp/reference/Task_wait_for_completion.md)
