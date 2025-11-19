# DatasetExport.create

Create a new dataset export.

## Usage

``` r
DatasetExport.create(
  dataset_id,
  format = "json",
  params = list(),
  follow = FALSE,
  env = get_connection(),
  ...
)
```

## Arguments

- dataset_id:

  The target dataset ID.

- format:

  (optional) The export format (default: json).

- params:

  (optional) Query parameters for the export.

- follow:

  (default: FALSE) Follow the export task until it completes.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional dataset export parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
DatasetExport.create(
  dataset_id = 12345,
  format = "json",
  params = list(fields = c("field_1"), limit = 100)
)
} # }
```
