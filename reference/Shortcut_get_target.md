# Get Shortcut target

Resolves the target of a shortcut into its object type.

## Usage

``` r
Shortcut_get_target(obj, allow_null_target = TRUE)
```

## Arguments

- obj:

  `Object`

- allow_null_target:

  Bool (Optional). If False will raise an error instead of returning
  NULL

## Value

Object of type `Vault` or `Object` or `character` or `NULL` depending on
the target
