# fetch all the pages for a possibly incomplete paginated API result

fetch all the pages for a possibly incomplete paginated API result

## Usage

``` r
fetch_all(x, ..., parallel = FALSE, workers = 4, verbose = FALSE)
```

## Arguments

- x:

  an API result

- ...:

  passed to future.apply::future_lapply()

- parallel:

  whether to parallelize the API calls.

- workers:

  in parallel mode, the number of concurrent requests to make

- verbose:

  whether to output debugging information, mostly for development

## Value

the object resulting in combining the current object/page and all
subsequent pages
