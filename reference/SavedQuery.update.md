# SavedQuery.update

Updates the attributes of an existing saved query.

## Usage

``` r
SavedQuery.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the saved query to update.

- env:

  (optional) Custom client environment.

- ...:

  Saved query attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
SavedQuery.update(
  id = "1234",
  name = "New query Name",
)
} # }
```
