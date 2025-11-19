# set the default connection

N.B: use conn=NULL to unset the default connection may die on bad
connection

## Usage

``` r
set_connection(conn, check = TRUE)
```

## Arguments

- conn:

  a EDP connection object (as a named list or environment)

- check:

  whether to check the connection, mostly for debugging purposes
