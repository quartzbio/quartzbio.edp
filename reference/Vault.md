# fetches a vault

N.B:

- if called without `id`, `full_path` or `name`, it fetches the
  *personal vault* of the connected user.

- dies if multiple vaults are matched

## Usage

``` r
Vault(id = NULL, full_path = NULL, name = NULL, conn = get_connection())
```

## Arguments

- id:

  the Vault ID or object to fetch

- full_path:

  the full path of the vault to fetch

- name:

  the name of the the vault to fetch

- conn:

  a EDP connection object (as a named list or environment)

## Value

the vault as a list with class `Vault`, or NULL if no matching vault is
found

## Examples

``` r
if (FALSE) { # \dontrun{
# with no argument, fetch the connected user personal vault
v <- Vault()

# by id
v2 <- Vault(v$id)

# by full_path
v2 <- Vault(full_path = v$full_path)

# by name
v2 <- Vault(name = "Public")
} # }
```
