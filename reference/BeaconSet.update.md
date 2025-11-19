# BeaconSet.update

Updates the attributes of an existing beacon set.

## Usage

``` r
BeaconSet.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the beacon set to update.

- env:

  (optional) Custom client environment.

- ...:

  Beacon set attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
BeaconSet.update(
  id = "1234",
  title = "New Beacon Set Title"
)
} # }
```
