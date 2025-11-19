# Configure log file and set the log-level

Setup the log record appender function for the file provided

## Usage

``` r
configure_logger(log_file, log_level = "INFO")
```

## Arguments

- log_file:

  Path to the file to log records

- log_level:

  Set log level. Default is set to INFO. Available levels: FATAL, ERROR,
  WARN, INFO, DEBUG

## Value

The log file, if logging file is configured successfully, `"console"` if
logging defaults to console or `NULL` if logging is disabled (due to
invalid path or missing logger package).
