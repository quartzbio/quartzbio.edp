# BeaconSet.create

Create a new beacon set.

## Usage

``` r
BeaconSet.create(
  title,
  description,
  is_shared = FALSE,
  env = get_connection(),
  ...
)
```

## Arguments

- title:

  The title displayed for the beacon set.

- description:

  (optional) An optional description for the new beacon set.

- is_shared:

  If TRUE, everyone else in your account will be able to see and query
  the beacon set, but will not be able to edit it. (Default: FALSE)

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional beacon set attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
BeaconSet.create(
  title = "My new beacon set",
)
} # }
```
