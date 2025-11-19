# Dataset.query

Queries a QuartzBio EDP dataset and returns an R data frame containing
all records. Returns a single page of results otherwise (default).

## Usage

``` r
Dataset.query(
  id,
  paginate = FALSE,
  use_field_titles = TRUE,
  env = get_connection(),
  ...
)
```

## Arguments

- id:

  The ID of a QuartzBio EDP dataset, or a Dataset object.

- paginate:

  When set to TRUE, retrieves all records (memory permitting).

- use_field_titles:

  (optional) Use field title instead of field name for query.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.query("12345678790", paginate = TRUE)
} # }
```
