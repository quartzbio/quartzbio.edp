# Record a log message with the given log level

Add log messages with the given log level

## Usage

``` r
log_message(level, content)
```

## Arguments

- level:

  log level Available levels: FATAL, ERROR, WARN, INFO, DEBUG

- content:

  message to be logged

## Examples

``` r
if (FALSE) { # \dontrun{
log_message("INFO", "This is a info message")
log_message("WARN", "This is a warning")
log_message("ERROR", "This is an error")
log_message("FATAL", "this is a fatal message")
log_message("DEBUG", "this is a debug")
} # }
```
