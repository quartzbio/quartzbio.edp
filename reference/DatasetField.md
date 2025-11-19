# fetches a field metadata of a dataset by ID or (datasetid, field_name)

fetches a field metadata of a dataset by ID or (datasetid, field_name)

## Usage

``` r
DatasetField(
  field_id = NULL,
  dataset_id = NULL,
  name = NULL,
  conn = get_connection()
)
```

## Arguments

- field_id:

  a Field object ID.

- dataset_id:

  a Dataset ID as a string

- name:

  The name of the field

- conn:

  a EDP connection object (as a named list or environment)

## Value

a DatasetField object
