# Object.get_by_path

A helper function to get an object on QuartzBio EDP by its path. Used as
a pass-through function from some Vault methods.

## Usage

``` r
Object.get_by_path(path, env = get_connection(), ...)
```

## Arguments

- path:

  The path to the object, relative to a vault.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
Object.get_by_path("/ClinVar")
} # }
```
