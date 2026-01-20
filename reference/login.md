# login

Store and verify your QuartzBio EDP credentials.

## Usage

``` r
login(
  api_token = Sys.getenv("QUARTZBIO_ACCESS_TOKEN"),
  api_host = Sys.getenv("QUARTZBIO_API_HOST")
)
```

## Arguments

- api_token:

  Your QuartzBio EDP API token

- api_host:

  QuartzBio EDP API host (default: https://api.solvebio.com)

## Examples

``` r
if (FALSE) { # \dontrun{
login()
} # }
```
