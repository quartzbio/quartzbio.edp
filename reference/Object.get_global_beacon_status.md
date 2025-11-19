# Object.get_global_beacon_status

Retrieves the global beacon status for the specified dataset.

## Usage

``` r
Object.get_global_beacon_status(
  id,
  raise_on_disabled = FALSE,
  env = get_connection()
)
```

## Arguments

- id:

  The ID of a QuartzBio EDP dataset.

- raise_on_disabled:

  Whether to raise an exception if Global Beacon is disabled or to
  return NULL.

- env:

  (optional) Custom client environment.

## Examples

``` r
if (FALSE) { # \dontrun{
Object.get_global_beacon_status("1234567890")
Object.get_global_beacon_status("1234567890", raise_on_disabled = TRUE)
} # }
```
