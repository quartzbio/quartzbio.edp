# queries data into a dataset.

queries data into a dataset.

## Usage

``` r
Dataset_query(
  dataset_id,
  filters = NULL,
  facets = NULL,
  fields = NULL,
  exclude_fields = c("_id", "_commit"),
  ordering = NULL,
  query = NULL,
  limit = 10000,
  offset = NULL,
  all = FALSE,
  meta = TRUE,
  parallel = FALSE,
  workers = 4,
  conn = get_connection(),
  ...
)
```

## Arguments

- dataset_id:

  a Dataset ID as a string

- filters:

  a filter expression as a JSON string.

- facets:

  A valid facets objects.

- fields:

  The fields to add.

- exclude_fields:

  A list of fields to exclude in the results, as a character vector.

- ordering:

  A list of fields to order/sort the results with, as a character
  vector.

- query:

  a string that matches any objects whose path contains that string.

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- offset:

  the file offset (starts from 0).

- all:

  whether to fetch all data, by iterating if needed.

- meta:

  whether to retrieve fields meta data information to properly format,
  reorder and rename the data frame

- parallel:

  whether to parallelize the API calls.

- workers:

  in parallel mode, the number of concurrent requests to make

- conn:

  a EDP connection object (as a named list or environment)

- ...:

  Additional query parameters, passed to .request().

  <https://docs.solvebio.com/>
