# GlobalSearch.subjects

Performs a Global Search based on provided filters, entities, queries,
and returns an R data frame containing subjects from API response.

## Usage

``` r
GlobalSearch.subjects(env = get_connection(), ...)
```

## Arguments

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, entities, query,
  limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
GlobalSearch.subjects(entities = '[["gene","BRCA2"]]')
} # }
```
