# connect to the QuartzBio EDP API using a saved profile

connect to the QuartzBio EDP API using a saved profile

## Usage

``` r
connect_with_profile(..., check = TRUE)
```

## Arguments

- ...:

  Arguments passed on to
  [`read_connection_profile`](https://quartzbio.github.io/quartzbio.edp/reference/read_connection_profile.md)

  `profile`

  :   the name of the profile, as a string

  `path`

  :   the path to the connection profiles file, as a string

- check:

  whether to check the connection, mostly for debugging purposes
