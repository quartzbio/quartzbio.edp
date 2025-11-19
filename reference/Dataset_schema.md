# Get dataset schema

Retrieves the schema of the Quartzbio EDP dataset.

## Usage

``` r
Dataset_schema(id = NULL, full_path = NULL, parquet_path = NULL)
```

## Arguments

- id:

  (character) The ID of a QuartzBio EDP dataset.

- full_path:

  (character) a valid dataset full path, including the account, vault
  and path to EDP Dataset.

- parquet_path:

  (character) provide a parquet file/ URI connection

## Value

A Schema object containing Fields, which maps to the data types.
