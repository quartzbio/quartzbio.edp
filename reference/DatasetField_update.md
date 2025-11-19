# updates an existing Dataset Field.

updates an existing Dataset Field.

## Usage

``` r
DatasetField_update(
  field_id,
  data_type = NULL,
  title = NULL,
  description = NULL,
  ordering = NULL,
  entity_type = NULL,
  expression = NULL,
  is_hidden = NULL,
  is_list = NULL,
  url_template = NULL,
  conn = get_connection()
)
```

## Arguments

- field_id:

  a Field object ID.

- data_type:

  the data type. one of:

  - auto (the default)

  - boolean - Either True, False, or null

  - date - A string in ISO 8601 format, for example:
    `2017-03-29T14:52:01`

  - double - A double-precision 64-bit IEEE 754 floating point.

  - float - single-precision 32-bit IEEE 754 floating point.

  - integer A signed 32-bit integer with a minimum value of -231 and a
    maximum value of 231-1.

  - long A signed 64-bit integer with a minimum value of -263 and a
    maximum value of 263-1.

  - object A key/value, JSON-like object, similar to a Python
    dictionary.

  - string A valid UTF-8 string up to 32,766 characters in length.

  - text A valid UTF-8 string of any length, indexed for full-text
    search.

  - blob A valid UTF-8 string of any length, not indexed for search.

- title:

  The field's display name, shown in the UI and in CSV/Excel exports, as
  a string

- description:

  the description as a string.

- ordering:

  A list of fields to order/sort the results with, as a character
  vector.

- entity_type:

  A valid entity type:

  - dataset - a Dataset ID (510110013133189334)

  - gene - A gene (EGFR)

  - genomic_region - A genomic region (GRCH38-7-55019017-55211628)

  - literature - A PubMed ID (19915526)

  - sample - A sample identifier (TCGA-02-0001)

  - variant - A genomic variant (GRCH38-7-55181378-55181378-T)

- expression:

  EDP xpressions are Python-like formulas that can be used to pull data
  from datasets, calculate statistics, or run advanced algorithms.

- is_hidden:

  whether the field should be hidden from the UI.

- is_list:

  whether the result is expected to be a list.

- url_template:

  A URL template with one or more "value" sections that will be
  interpolated with the field value and displayed as a link in the
  dataset table.

- conn:

  a EDP connection object (as a named list or environment)

## Value

a DatasetField object
