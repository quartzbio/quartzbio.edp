# Initiate a Dataset export to parquet

Create a dataset export to parquet file and return the URL to export
file

## Usage

``` r
dataset_export_to_parquet(id = NULL, full_path = NULL, conn = get_connection())
```

## Arguments

- id:

  (character) The ID of a QuartzBio EDP dataset, or a Dataset object.

- full_path:

  (character) a valid dataset full path, including the account, vault
  and path to EDP Dataset.

- conn:

  (optional) Custom client environment.

## Value

URL to the parquet file for the given EDP dataset. If there is an
failure, an error will be raised.
