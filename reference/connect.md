# connect to the QuartzBio EDP API and return the connection

connect to the QuartzBio EDP API and return the connection

## Usage

``` r
connect(
  secret = get_env("EDP_API_SECRET", get_env("QUARTZBIO_ACCESS_TOKEN",
    get_env("QUARTZBIO_API_KEY", get_env("SOLVEBIO_ACCESS_TOKEN",
    get_env("SOLVEBIO_API_KEY"))))),
  host = get_env("EDP_API_HOST", get_env("QUARTZBIO_API_HOST",
    get_env("SOLVEBIO_API_HOST"))),
  check = TRUE
)
```

## Arguments

- secret:

  a QuartzBio EDP **API key** or **token** as a string. Defaults to the
  `EDP_API_SECRET` environment variable if set, otherwise to the
  `QUARTZBIO_ACCESS_TOKEN` var, then to `QUARTZBIO_API_KEY`, then to
  legacy `SOLVEBIO_ACCESS_TOKEN` var, then to to the `SOLVEBIO_API_KEY`
  var.

- host:

  the QuartzBio EDP **API host** as a string. Defaults to the
  `EDP_API_HOST` environment variable if set, otherwise to the
  `QUARTZBIO_API_HOST` var, then to the legacy `SOLVEBIO_API_HOST` var.

- check:

  whether to check the connection, mostly for debugging purposes

## Value

a connection object

## Examples

``` r
if (FALSE) { # \dontrun{
#  using API key
conn <- connect("MYKEY")
# using env vars
conn <- connect()
# using token and explicit host
conn <- connect("MYTOKEN", "https://xxxx.yy.com")
} # }
```
