# Object.data

Returns one page of documents from a QuartzBio EDP file (object) and
processes the response.

## Usage

``` r
Object.data(id, filters, col.names = NULL, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP file (vault object).

- filters:

  (optional) Query filters.

- col.names:

  (optional) Force data frame column name ordering.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Object.data("1234567890")
} # }
```
