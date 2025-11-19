# login

Store and verify your QuartzBio EDP credentials.

## Usage

``` r
login(
  api_key = Sys.getenv("SOLVEBIO_API_KEY"),
  api_token = Sys.getenv("SOLVEBIO_ACCESS_TOKEN"),
  api_host = Sys.getenv("SOLVEBIO_API_HOST")
)
```

## Arguments

- api_key:

  Your QuartzBio EDP API key

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
