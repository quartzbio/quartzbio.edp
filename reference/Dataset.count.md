# Dataset.count

Returns the total number of records for a given QuartzBio EDP dataset.

## Usage

``` r
Dataset.count(id, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP dataset, or a Dataset object.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
dataset <- Dataset.get_by_full_path("solvebio:public:/ClinVar/3.7.4-2017-01-30/Variants-GRCh37")
Dataset.count(dataset)
Dataset.count(dataset, filters = '[["gene_symbol", "BRCA2"]]')
} # }
```
