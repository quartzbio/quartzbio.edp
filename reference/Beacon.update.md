# Beacon.update

Updates the attributes of an existing beacon.

## Usage

``` r
Beacon.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the beacon to update.

- env:

  (optional) Custom client environment.

- ...:

  Beacon attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
Beacon.update(
  id = "1234",
  title = "New Beacon Title"
)
} # }
```
