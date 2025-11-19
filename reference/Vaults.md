# fetches a list of vaults

fetches a list of vaults

## Usage

``` r
Vaults(
  vault_type = NULL,
  tags = NULL,
  user_id = NULL,
  storage_class = NULL,
  account_id = NULL,
  page = NULL,
  limit = NULL,
  conn = get_connection()
)
```

## Arguments

- vault_type:

  the type of vault ('user', 'general') as a string

- tags:

  a list of tags as a character vector.

- user_id:

  a user id (or User object) as a string

- storage_class:

  The Storage class of the vault
  `('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')`
  as a string.

- account_id:

  an Account ID as a string.

- page:

  The number of the page to fetch, as an integer. starts from 1. See
  also `limit`.

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- conn:

  a EDP connection object (as a named list or environment)
