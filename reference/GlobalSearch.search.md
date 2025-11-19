# GlobalSearch.search

Performs a Global Search based on provided filters, entities, queries,
and returns an R data frame containing results from API response.
Returns a single page of results otherwise (default).

## Usage

``` r
GlobalSearch.search(paginate = FALSE, env = get_connection(), ...)
```

## Arguments

- paginate:

  When set to TRUE, retrieves all records (memory permitting).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, entities, query,
  limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
# No filters applied
GlobalSearch.search()

# Global Beacon search
GlobalSearch.search(entities = '[["gene","BRCA2"]]')

# #Type filter (only vaults)
GlobalSearch.search(filters = '[{"and":[["type__in",["vault"]]]}]')

# Advanced search
GlobalSearch.search(query = "fuji")
} # }
```
