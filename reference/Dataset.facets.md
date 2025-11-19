# Dataset.facets

Retrieves aggregated statistics or term counts for one or more fields in
a QuartzBio EDP dataset. Returns a list of data frames, one for each
requested facet.

## Usage

``` r
Dataset.facets(id, facets, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of a QuartzBio EDP dataset, or a Dataset object.

- facets:

  A list of one or more field facets.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional query parameters (e.g. filters, limit, offset).

## Examples

``` r
if (FALSE) { # \dontrun{
Dataset.facets("1234567890", list("clinical_significance", "gene_symbol"))
} # }
```
