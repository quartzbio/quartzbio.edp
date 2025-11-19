# Vault.create_dataset

Create a new dataset in a vault.

## Usage

``` r
Vault.create_dataset(id, path, name, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the vault.

- path:

  The path to the dataset, within the vault.

- name:

  The name (filename) for the dataset.

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional dataset creation parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
vault <- Vault.get_personal_vault()
Vault.create_dataset(vault$id, path = "/", name = "My Dataset")
} # }
```
