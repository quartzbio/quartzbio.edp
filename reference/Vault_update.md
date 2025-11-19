# updates a vault

N.B:

- the updated vault properties are overwritten, not merged!

- if `id` is NULL, this will create a new vault

## Usage

``` r
Vault_update(
  id,
  name = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  conn = get_connection()
)
```

## Arguments

- id:

  the Vault ID or object to fetch

- name:

  the vault name to create, as a string.

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

a Vault object

## Examples

``` r
if (FALSE) { # \dontrun{
v2 <- Vault_update(v$id,
  name = name, description = "desc",
  metadata = list(meta1 = "toto"), storage_class = "Performance", tags = "A"
)
# using methods
v3 <- update(v2, name = name, storage_class = "Temporary")
v4 <- update(vault_id, tags = LETTERS[1:5])
} # }
```
