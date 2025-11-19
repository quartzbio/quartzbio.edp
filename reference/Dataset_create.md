# creates a new Dataset.

creates a new Dataset.

## Usage

``` r
Dataset_create(
  vault_id,
  vault_path,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  capacity = NULL,
  conn = get_connection()
)
```

## Arguments

- vault_id:

  a Vault ID as a string (e.g. "19").

- vault_path:

  a Vault path, as a string (e.g. "/d1/d2/foo.csv")

- description:

  the description as a string.

- metadata:

  metadata as a named list.

- tags:

  a list of tags as a character vector.

- storage_class:

  The Storage class of the vault
  `('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')`
  as a string.

- capacity:

  The dataset capacity level (small, medium, or large).

- conn:

  a EDP connection object (as a named list or environment)
