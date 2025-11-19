# DatasetTemplate.update

Updates the attributes of an existing dataset template.

## Usage

``` r
DatasetTemplate.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the dataset template to update.

- env:

  (optional) Custom client environment.

- ...:

  Dataset template attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
DatasetTemplate.update(
  id = "1234",
  name = "New Template Name",
)
} # }
```
