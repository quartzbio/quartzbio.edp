# DatasetImport.create

Create a new dataset import. Either an object_id, manifest, or
data_records is required.

## Usage

``` r
DatasetImport.create(
  dataset_id,
  commit_mode = "append",
  env = get_connection(),
  ...
)
```

## Arguments

- dataset_id:

  The target dataset ID.

- commit_mode:

  (optional) The commit mode (default: append).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional dataset import attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
DatasetImport.create(dataset_id = 12345, upload_id = 12345)
} # }
```
