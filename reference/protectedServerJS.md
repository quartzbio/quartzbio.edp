# protectedServerUI

Returns ShinyJS-compatible JS code to support cookie-based token
storage.

## Usage

``` r
protectedServerJS()
```

## Examples

``` r
if (FALSE) { # \dontrun{
jscookie_src <- "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.0/js.cookie.js"
ui <- fluidPage(
  shiny::tags$head(
    shiny::tags$script(src = jscookie_src)
  ),
  useShinyjs(),
  extendShinyjs(
    text = quartzbio.edp::protectedServerJS(),
    functions = c("enableCookieAuth", "getCookie", "setCookie", "rmCookie")
  )
)
} # }
```
