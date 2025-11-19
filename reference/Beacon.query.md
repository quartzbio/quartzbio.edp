# Beacon.query

Query an individual beacon.

## Usage

``` r
Beacon.query(id, query, entity_type, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the beacon.

- query:

  The entity ID or query string.

- entity_type:

  (optional) A valid QuartzBio EDP entity type.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
Beacon.query(
  id = "1234",
  query = "BRCA2",
  entity_type = "gene"
)
} # }
```
