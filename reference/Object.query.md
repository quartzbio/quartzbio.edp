# Object.query

Queries a QuartzBio EDP file (vault object) and returns an R data frame
containing all records. Returns a single page of results otherwise
(default).

## Usage

``` r
Object.query(id, paginate = FALSE, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP file (vault object).

- paginate:

  When set to TRUE, retrieves all records (memory permitting).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Object.query("12345678790", paginate = TRUE)
} # }
```
