# Object.update

Updates the attributes of an existing vault object.

## Usage

``` r
Object.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the vault to update.

- env:

  (optional) Custom client environment.

- ...:

  Object attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
Object.update(
  id = "1234",
  filename = "New Name",
)
} # }
```
