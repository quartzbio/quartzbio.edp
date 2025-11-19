# BeaconSet.query

Query a beacon set (i.e. all the beacons within a beacon set).

## Usage

``` r
BeaconSet.query(id, query, entity_type, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the beacon set.

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
BeaconSet.query(
  id = "1234",
  query = "BRCA2",
  entity_type = "gene"
)
} # }
```
