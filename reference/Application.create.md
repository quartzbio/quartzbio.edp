# Application.create

Create a new QuartzBio EDP application.

## Usage

``` r
Application.create(name, redirect_uris, env = get_connection(), ...)
```

## Arguments

- name:

  The name of the application.

- redirect_uris:

  A list of space-separated OAuth2 redirect URIs.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional application attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
Application.create(
  name = "My new application",
  redirect_uris = "http://localhost:3838/"
)
} # }
```
