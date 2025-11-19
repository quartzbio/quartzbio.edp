# fetches a dataset.

fetches a dataset.

## Usage

``` r
Dataset(
  dataset_id = NULL,
  full_path = NULL,
  path = NULL,
  vault_id = NULL,
  conn = get_connection()
)
```

## Arguments

- dataset_id:

  a Dataset ID as a string

- full_path:

  an Object full path, including the account, vault and path.

- path:

  the path of an object, with the folders (e.g. "/d1/d2/foo.csv").

- vault_id:

  a Vault ID as a string (e.g. "19").

- conn:

  a EDP connection object (as a named list or environment)
