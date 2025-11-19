# Dataset.get_by_full_path

A helper function to get a dataset by its full path.

## Usage

``` r
Dataset.get_by_full_path(full_path, env = get_connection())
```

## Arguments

- full_path:

  A valid full path to a dataset.

- env:

  (optional) Custom client environment.

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.get_by_full_path("solvebio:public:/ClinVar/3.7.4-2017-01-30/Variants-GRCh37")
} # }
```
