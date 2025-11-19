# Vault.search

Search for objects in a specific vault.

## Usage

``` r
Vault.search(id, query, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the vault.

- query:

  The search query.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
vault <- Vault.get_personal_vault()
Vault.search("test")
} # }
```
