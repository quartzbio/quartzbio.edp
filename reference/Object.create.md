# Object.create

Create a QuartzBio EDP object.

## Usage

``` r
Object.create(
  vault_id,
  parent_object_id,
  object_type,
  filename,
  env = get_connection(),
  ...
)
```

## Arguments

- vault_id:

  The target vault ID.

- parent_object_id:

  The ID of the parent object (folder) or NULL for the vault root.

- object_type:

  The type of object (i.e. "folder").

- filename:

  The filename (i.e. the name) of the object.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional object attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
Object.create(
  vault_id = "1234567890",
  parent_object_id = NULL,
  object_type = "folder",
  filename = "My Folder"
)
} # }
```
