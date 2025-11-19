# Vault.datasets

Retrieves all datasets in a specific vault.

## Usage

``` r
Vault.datasets(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the vault.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
vault <- Vault.get_personal_vault()
Vault.datasets(vault$id)
} # }
```
