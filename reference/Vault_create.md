# creates a new EDP vault or updates an existing one.

cf https://docs.solvebio.com/reference/vaults/vaults/#create

## Usage

``` r
Vault_create(
  name,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  conn = get_connection()
)
```

## Arguments

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

## Details

if id is NULL, it will create a new vault, otherwise it will update the
vault with the corresponding id

## Examples

``` r
if (FALSE) { # \dontrun{
# simplest form
v <- Vault_create("my.new.vault")

# using all params
v <- Vault_create(
  name = "my.new.vault",
  description = "This is my own vault",
  metadata = list(a = 1, b = "toto", sublist = list(x = "str")),
  tags = c("TEST", "DATA"),
  storage_class = "Performance",
  conn = conn
)
} # }
```
