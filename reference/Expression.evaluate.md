# Evaluate a QuartzBio EDP expression.

Evaluate a QuartzBio EDP expression.

## Usage

``` r
Expression.evaluate(
  expression,
  data_type = "string",
  is_list = FALSE,
  data = NULL,
  raw = FALSE,
  env = get_connection()
)
```

## Arguments

- expression:

  The EDP expression string.

- data_type:

  The data type to cast the expression result.

- is_list:

  whether the result is expected to be a list.

- data:

  TODO

- raw:

  whether to return the raw response.

- env:

  Custom client environment.

## Examples

``` r
if (FALSE) { # \dontrun{
Expression.evaluate("1 + 1", data_type = "integer", is_list = FALSE)
} # }
```
