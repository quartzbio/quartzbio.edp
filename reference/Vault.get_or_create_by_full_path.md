# Vault.get_or_create_by_full_path

Retrieves or creates a specific vault by its full path (domain:vault).

## Usage

``` r
Vault.get_or_create_by_full_path(full_path, env = get_connection(), ...)
```

## Arguments

- full_path:

  The full path of a QuartzBio EDP vault.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
Vault.get_or_create_by_full_path("My New Vault")
} # }
```
