# create a model data frame from a list of column names and some meta data fields.

Creates a model empty data frame from a list of column names and meta
data fields of the EDP dataset.

## Usage

``` r
create_model_df_from_fields(cols, fields, titles = TRUE, ordering = TRUE)
```

## Arguments

- cols:

  list of column names

- fields:

  meta data fields from EDP dataset

- titles:

  Set the dataframe column names as per titles. Default is TRUE

- ordering:

  Set the order of columns based on ordering. Default is TRUE

## Value

A model empty R dataframe
