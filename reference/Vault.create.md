# Vault.create

Create a new QuartzBio EDP vault.

## Usage

``` r
Vault.create(name, env = get_connection(), ...)
```

## Arguments

- name:

  The unique name of the vault.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional vault attributes.

## Examples

``` r
if (FALSE) { # \dontrun{
Vault.create(name = "my-domain:MyVault")
} # }
```
