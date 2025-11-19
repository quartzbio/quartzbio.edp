# creates a folder.

creates a folder.

## Usage

``` r
Folder_create(
  vault_id,
  path,
  recursive = TRUE,
  parent_folder_id = NULL,
  conn = get_connection()
)
```

## Arguments

- vault_id:

  a Vault ID as a string (e.g. "19").

- path:

  the folder path to create

- recursive:

  whether to recursively create the parent folders if they do not exist.

- parent_folder_id:

  the ID of the parent folder.

- conn:

  a EDP connection object (as a named list or environment)

## Value

the folder as an Object
