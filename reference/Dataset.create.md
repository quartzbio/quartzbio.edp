# Dataset.create

Create an empty QuartzBio EDP dataset.

## Usage

``` r
Dataset.create(
  vault_id,
  vault_parent_object_id,
  name,
  env = get_connection(),
  ...
)
```

## Arguments

- vault_id:

  The ID of the vault.

- vault_parent_object_id:

  The parent object (folder) ID in the vault.

- name:

  The name of the dataset in the parent folder.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional dataset attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.create(vault_id = vault$id, vault_parent_object_id = NULL, name = "My Dataset")
} # }
```
