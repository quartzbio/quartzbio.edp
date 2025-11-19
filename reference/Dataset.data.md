# Dataset.data

Returns one page of documents from a QuartzBio EDP dataset and processes
the response.

## Usage

``` r
Dataset.data(id, filters, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP dataset, or a Dataset object.

- filters:

  (optional) Query filters.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.data("1234567890")
} # }
```
