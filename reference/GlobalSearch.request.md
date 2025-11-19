# GlobalSearch.request

Performs a single Global Search API request with the provided filters,
queries and entities. A single request will only retrieve one page of
results (based on the `limit` parameter). Use
[`GlobalSearch.search()`](https://quartzbio.github.io/quartzbio.edp/reference/GlobalSearch.search.md)
to retrieve all pages of results. Returns the full API response
(containing attributes: results, vaults, subjects, subjects_count,
total)

## Usage

``` r
GlobalSearch.request(
  query = NULL,
  filters,
  entities,
  env = get_connection(),
  ...
)
```

## Arguments

- query:

  (optional) Advanced search query.

- filters:

  (optional) Low-level filter specification.

- entities:

  (optional) Low-level entity specification.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
# No filters are applied
GlobalSearch.request()

# Global Beacon search
GlobalSearch.request(entities = '[["gene","BRCA2"]]')

# Type filter (only vaults)
GlobalSearch.request(filters = '[{"and":[["type__in",["vault"]]]}]')

# Advanced search
GlobalSearch.request(query = "fuji")


# Multiple filters and entities
GlobalSearch.request(
  entities = '[["gene","BRCA2"]]',
  filters = '[{
               "and": [
                      {"and": [
                         ["created_at__range",["2021-11-28","2021-12-28"]]]},
                         ["type__in",["dataset"]]
                     ]
             }]'
)
} # }
```
