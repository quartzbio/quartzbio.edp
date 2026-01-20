# creates a shortcut.

creates a shortcut.

## Usage

``` r
Shortcut_create(
  vault_id,
  vault_path,
  target,
  tags = list(),
  conn = get_connection()
)
```

## Arguments

- vault_id:

  a Vault ID as a string (e.g. "19").

- vault_path:

  a Vault path, as a string (e.g. "/d1/d2/foo.csv")

- target:

  named list. Only relevant when `object_type` is `shortcut`. Must
  contain `object_type`. When `object_type` is `url` then the second
  field must be `url`. For other `object_type`s `id` should be provided.
  Shortcuts can be created to:

  - vaults (object_type='vault')

  - files (object_type='file')

  - datasets (object_type='dataset')

  - folders (object_type='folder')

  - URLs (object_type='url')

- tags:

  a list of tags as a character vector.

- conn:

  a EDP connection object (as a named list or environment)

## Value

the shortcut as an Object

## Details

Shortcuts cannot be created to:

- the containing vault of the shortcut file.

- the parent folder or any ancestor of the shortcut file.

- a deleted object

- a non-existent object

- vaults that are not of type 'general'
