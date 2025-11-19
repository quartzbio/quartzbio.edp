# Annotate a data table/frame with additional fields.

Annotate a data table/frame with additional fields.

## Usage

``` r
Annotator.annotate(
  records,
  fields,
  include_errors = FALSE,
  raw = FALSE,
  env = get_connection()
)
```

## Arguments

- records:

  The data to annotate as a data frame.

- fields:

  The fields to add.

- include_errors:

  whether to include errors in the output.

- raw:

  whether to return the raw response.

- env:

  Custom client environment.
