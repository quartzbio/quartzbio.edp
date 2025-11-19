# GlobalSearch.subjects_count

Performs a Global Search based on provided filters, entities, queries,
and returns the total number of subjects from API response.

## Usage

``` r
GlobalSearch.subjects_count(env = get_connection(), ...)
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
GlobalSearch.subjects_count(entities = '[["gene","BRCA2"]]')
} # }
```
