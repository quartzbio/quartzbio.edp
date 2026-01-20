# creates an Object.

creates an Object.

## Usage

``` r
Object_create(
  vault_id,
  filename,
  object_type,
  parent_object_id = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  capacity = NULL,
  mimetype = NULL,
  size = NULL,
  md5 = NULL,
  target = NULL,
  conn = get_connection()
)
```

## Arguments

- vault_id:

  a Vault ID as a string (e.g. "19").

- filename:

  an Object filename, without the parent folder (e.g. "foo.csv")

- object_type:

  the type of an object, one of "file", "folder", "dataset" or
  "shortcut".

- parent_object_id:

  the ID of the parent of the Object.

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

- mimetype:

  the MIME type of the Object.

- size:

  The size of the object.

- md5:

  a MD5 fingerprint, as a string.

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

- conn:

  a EDP connection object (as a named list or environment)

## Value

the object as as list with class Object
