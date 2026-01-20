# fetches a shortcut by id or (vault_id, path)

fetches a shortcut by id or (vault_id, path)

## Usage

``` r
Shortcut(id = NULL, path = NULL, vault_id = NULL, conn = get_connection())
```

## Arguments

- id:

  the shortcut ID.

- path:

  the path of an object, starting from the vault's root directory. The
  path must include all intermediate folders and end with the object’s
  name (e.g. "/d1/d2/foo.csv" or "/d1/d2/").

- vault_id:

  a Vault ID as a string (e.g. "19").

- conn:

  a EDP connection object (as a named list or environment)
