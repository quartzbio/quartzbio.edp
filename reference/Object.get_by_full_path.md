# Object.get_by_full_path

A helper function to get an object on QuartzBio EDP by its full path.

## Usage

``` r
Object.get_by_full_path(full_path, env = get_connection(), ...)
```

## Arguments

- full_path:

  The full path to the object.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
Object.get_by_full_path("solvebio:public:/ClinVar")
} # }
```
