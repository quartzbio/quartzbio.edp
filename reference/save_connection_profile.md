# save a connection profile

save a connection profile

## Usage

``` r
save_connection_profile(
  conn,
  profile = get_env("EDP_PROFILE", "default"),
  path = get_env("EDP_CONFIG", "~/.qb/edp.json"),
  overwrite = FALSE
)
```

## Arguments

- conn:

  a EDP connection object (as a named list or environment)

- profile:

  the name of the profile, as a string

- path:

  the path to the connection profiles file, as a string

- overwrite:

  whether to overwrite an existing profile

## See also

Other connection:
[`read_connection_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/read_connection_profile.md)
