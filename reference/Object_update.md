# updates an Object.

updates an Object.

## Usage

``` r
Object_update(
  id,
  filename = NULL,
  object_type = NULL,
  parent_object_id = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  conn = get_connection()
)
```

## Arguments

- id:

  an Object ID

- filename:

  an Object filename, without the parent folder (e.g. "foo.csv")

- object_type:

  the type of an object, one of "file", "folder", or "dataset".

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

- conn:

  a EDP connection object (as a named list or environment)

## Value

the object as as list with class Object
