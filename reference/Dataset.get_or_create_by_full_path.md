# Dataset.get_or_create_by_full_path

A helper function to get or create a dataset by its full path.

## Usage

``` r
Dataset.get_or_create_by_full_path(full_path, env = get_connection(), ...)
```

## Arguments

- full_path:

  A valid full path to a dataset.

- env:

  (optional) Custom client environment.

- ...:

  Additional dataset creation parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.get_or_create_by_full_path("MyVault:/folder/sub-folder/dataset")
} # }
```
