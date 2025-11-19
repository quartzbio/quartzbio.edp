# Object.fields

Retrieves the list of fields for a file (JSON, CSV, or TSV).

## Usage

``` r
Object.fields(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP file (vault object).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Object.fields("1234567890")
} # }
```
