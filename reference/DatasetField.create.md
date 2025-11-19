# DatasetField.create

Create a new dataset field.

## Usage

``` r
DatasetField.create(
  dataset_id,
  name,
  data_type = "auto",
  env = get_connection(),
  ...
)
```

## Arguments

- dataset_id:

  The dataset ID.

- name:

  The name of the dataset field.

- data_type:

  (optional) The data type for the field (default: auto).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional dataset import attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
DatasetField.create(dataset_id = 12345, name = "my_field", title = "My Field", data_type = "string")
} # }
```
