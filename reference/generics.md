# deletes an object from EDP

deletes an object from EDP

fetches an object using its ID

fetches the vault related to an object

## Usage

``` r
delete(x, conn = attr(x, "connection"))

fetch(x, conn = attr(x, "connection"))

fetch_vaults(x, conn = attr(x, "connection"))
```

## Arguments

- x:

  the object to delete

- conn:

  a EDP connection object (as a named list or environment)

## Value

the decorated object

the vault, or NULL if not applicable
