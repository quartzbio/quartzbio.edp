# Application.update

Updates the attributes of an existing application.

## Usage

``` r
Application.update(client_id, env = get_connection(), ...)
```

## Arguments

- client_id:

  The client ID for the application.

- env:

  (optional) Custom client environment.

- ...:

  Application attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
Application.update(
  "abcd1234",
  name = "New app name"
)
} # }
```
