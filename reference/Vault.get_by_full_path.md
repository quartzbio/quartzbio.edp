# Vault.get_by_full_path

Retrieves a specific vault by its full path (domain:vault).

## Usage

``` r
Vault.get_by_full_path(full_path, verbose = TRUE, env = get_connection())
```

## Arguments

- full_path:

  The full path of a QuartzBio EDP vault.

- verbose:

  Print warning/error messages (default: TRUE).

- env:

  (optional) Custom client environment.

## Examples

``` r
if (FALSE) { # \dontrun{
Vault.get_by_full_path("QuartzBio EDP:Public")
} # }
```
