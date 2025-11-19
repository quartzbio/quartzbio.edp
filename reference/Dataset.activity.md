# Dataset.activity

A helper function to get or follow the current activity on a dataset.

## Usage

``` r
Dataset.activity(id, follow = TRUE, env = get_connection())
```

## Arguments

- id:

  String The ID of a QuartzBio EDP dataset

- follow:

  Follow active tasks until they complete.

- env:

  (optional) Custom client environment.

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.activity("1234567890")
} # }
```
