# Task.follow

A helper function to follow a specific task until it gets completed.

## Usage

``` r
Task.follow(id, env = get_connection(), interval = 2)
```

## Arguments

- id:

  String The ID of a task.

- env:

  (optional) Custom client environment.

- interval:

  1.  Delay in seconds between each completion status query

## Value

the task object

## Examples

``` r
if (FALSE) { # \dontrun{
Task.follow("1234567890")
} # }
```
