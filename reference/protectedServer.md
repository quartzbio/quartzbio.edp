# protectedServer

Wraps an existing Shiny server in an OAuth2 flow.

## Usage

``` r
protectedServer(
  server,
  client_id,
  client_secret = NULL,
  base_url = "https://my.solvebio.com"
)
```

## Arguments

- server:

  Your original Shiny server function.

- client_id:

  Your application's client ID.

- client_secret:

  (optional) Your application's client secret.

- base_url:

  (optional) Override the default login host (default:
  https://my.solvebio.com).

## Examples

``` r
if (FALSE) { # \dontrun{
protectedServer(
  server = server,
  client_id = "abcd1234"
)
} # }
```
