# GlobalSearch.facets

Performs a Global Search based on provided filters, entities, queries,
and returns an R data frame containing the facets results from API
response.

## Usage

``` r
GlobalSearch.facets(facets, env = get_connection(), ...)
```

## Arguments

- facets:

  Facets list.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, entities,
  query).

## Examples

``` r
if (FALSE) { # \dontrun{
GlobalSearch.facets(facets = "study")
} # }
```
