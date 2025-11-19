# New function for EDP auth of shiny app. Returns the updated session with EDP connection to be used in shiny app

New function for EDP auth of shiny app. Returns the updated session with
EDP connection to be used in shiny app

## Usage

``` r
quartzbio_shiny_auth(
  input,
  session,
  client_id,
  client_secret = NULL,
  base_url,
  create_logfile = FALSE
)
```

## Arguments

- input:

  input

- session:

  session

- client_id:

  client_id

- client_secret:

  secret

- base_url:

  BASE URL

- create_logfile:

  (logical) Create a file to log records. Default is set to FALSE. Log
  file name will be generated automatically.
