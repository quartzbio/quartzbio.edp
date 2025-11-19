# Vault.update

Updates the attributes of an existing vault.

## Usage

``` r
Vault.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the vault to update.

- env:

  (optional) Custom client environment.

- ...:

  Vault attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
Vault.update(
  id = "1234",
  name = "New Vault Name",
)
} # }
```
