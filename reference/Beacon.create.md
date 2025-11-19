# Beacon.create

Add a new beacon to an existing beacon set. The beacon set must already
exist in order to add beacons.

## Usage

``` r
Beacon.create(
  beacon_set_id,
  vault_object_id,
  title,
  env = get_connection(),
  ...
)
```

## Arguments

- beacon_set_id:

  The ID of the parent beacon set.

- vault_object_id:

  The ID of the vault object (i.e. dataset) queried by the beacon.

- title:

  The title displayed for the beacon.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional beacon attributes (such as description and
  params).

## Examples

``` r
if (FALSE) { # \dontrun{
Beacon.create(
  beacon_set_id = "1234",
  vault_object_id = "1234567890",
  title = "My new beacon"
)
} # }
```
