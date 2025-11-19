# Dataset.fields

Retrieves the list of fields and field metadata for a dataset.

## Usage

``` r
Dataset.fields(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP dataset, or a Dataset object.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.fields("1234567890")
} # }
```
