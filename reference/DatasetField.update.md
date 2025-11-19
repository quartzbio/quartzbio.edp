# DatasetField.update

Updates the attributes of an existing dataset field. NOTE: The data_type
of a field cannot be changed.

## Usage

``` r
DatasetField.update(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the dataset field to update.

- env:

  (optional) Custom client environment.

- ...:

  Dataset field attributes to change.

## Examples

``` r
if (FALSE) { # \dontrun{
DatasetField.update(
  id = "1234",
  title = "New Field Title"
)
} # }
```
