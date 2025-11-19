# Dataset_load

Loads large Quartzbio EDP dataset and returns an R data frame containing
all records.

## Usage

``` r
Dataset_load(
  id = NULL,
  full_path = NULL,
  get_schema = FALSE,
  filter_expr = NULL,
  ...
)
```

## Arguments

- id:

  (character) The ID of a QuartzBio EDP dataset.

- full_path:

  (character) a valid dataset full path, including the account, vault
  and path to EDP Dataset.

- get_schema:

  (boolean) Retrieves the schema of the Quartzbio EDP dataset loaded.
  Default value: FALSE

- filter_expr:

  (character) A arrow Expression to filter the scanned rows by, or
  (default) to keep all rows. Check
  [`arrow::Scanner()`](https://arrow.apache.org/docs/r/reference/Scanner.html)

- ...:

  Arguments passed on to
  [`arrow::read_parquet`](https://arrow.apache.org/docs/r/reference/read_parquet.html)

  `col_select`

  :   A character vector of column names to keep, as in the "select"
      argument to `data.table::fread()`, or a [tidy selection
      specification](https://tidyselect.r-lib.org/reference/eval_select.html)
      of columns, as used in
      [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html).

  `as_data_frame`

  :   Should the function return a `tibble` (default) or an Arrow
      [Table](https://arrow.apache.org/docs/r/reference/Table-class.html)?

## Value

A `tibble` which is the default, or an Arrow Table otherwise. If the
`get_schema` parameter is set to `TRUE`, the function returns a list
containing both the `tibble` and its schema.
