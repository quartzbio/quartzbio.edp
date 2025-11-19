# read a connection profile

read a connection profile

## Usage

``` r
read_connection_profile(
  profile = get_env("EDP_PROFILE", "default"),
  path = get_env("EDP_CONFIG", "~/.qb/edp.json")
)
```

## Arguments

- profile:

  the name of the profile, as a string

- path:

  the path to the connection profiles file, as a string

## Value

the connection for the given profile as a named list, or die if there is
no such profile

## See also

Other connection:
[`save_connection_profile()`](https://quartzbio.github.io/quartzbio.edp/reference/save_connection_profile.md)
