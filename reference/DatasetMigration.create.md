# DatasetMigration.create

Create a new dataset migration.

## Usage

``` r
DatasetMigration.create(
  source_id,
  target_id,
  commit_mode = "append",
  source_params = NULL,
  target_fields = NULL,
  include_errors = FALSE,
  env = get_connection(),
  ...
)
```

## Arguments

- source_id:

  The source dataset ID.

- target_id:

  The target dataset ID.

- commit_mode:

  (optional) The commit mode (default: append).

- source_params:

  (optional) The query parameters used on the source dataset.

- target_fields:

  (optional) A list of valid dataset fields to add or override in the
  target dataset.

- include_errors:

  (optional) If TRUE, a new field (\_errors) will be added to each
  record containing expression evaluation errors (default: FALSE).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional dataset migration attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
DatasetMigration.create(dataset_id = 12345, upload_id = 12345)
} # }
```
