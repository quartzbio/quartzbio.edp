# fetches the fields of a dataset.

fetches the fields of a dataset.

## Usage

``` r
DatasetFields(
  dataset_id,
  limit = NULL,
  page = NULL,
  all = FALSE,
  conn = get_connection(),
  ...
)
```

## Arguments

- dataset_id:

  a Dataset ID as a string

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- page:

  The number of the page to fetch, as an integer. starts from 1. See
  also `limit`.

- all:

  whether to fetch all data, by iterating if needed.

- conn:

  a EDP connection object (as a named list or environment)

- ...:

  Additional query parameters, passed to .request().

  <https://docs.solvebio.com/>

## Value

a DatasetFieldList object
