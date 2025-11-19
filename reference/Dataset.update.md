# Dataset.update

Updates the attributes of an existing dataset.

## Usage

``` r
Dataset.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the dataset to update.

- env:

  (optional) Custom client environment.

- ...:

  Dataset attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.update(
  id = "1234",
  name = "New Dataset Name",
)
} # }
```
