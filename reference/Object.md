# fetches an object.

fetches an object.

## Usage

``` r
Object(
  id = NULL,
  full_path = NULL,
  path = NULL,
  vault_id = NULL,
  object_type = NULL,
  conn = get_connection()
)
```

## Arguments

- id:

  an Object ID

- full_path:

  an Object full path, including the account, vault and path.

- path:

  the path of an object, starting from the vault's root directory. The
  path must include all intermediate folders and end with the object’s
  name (e.g. "/d1/d2/foo.csv" or "/d1/d2/").

- vault_id:

  a Vault ID as a string (e.g. "19").

- object_type:

  the type of an object, one of "file", "folder", "dataset" or
  "shortcut".

- conn:

  a EDP connection object (as a named list or environment)
