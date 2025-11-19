# Vault.create_folder

Create a new folder in a vault.

## Usage

``` r
Vault.create_folder(id, path, recursive = FALSE, env = get_connection(), ...)
```

## Arguments

- id:

  The ID of the vault.

- path:

  The path to the folder, within the vault.

- recursive:

  Create all parent directories that do not yet exist (default: FALSE).

- env:

  (optional) Custom client environment.

- ...:

  (optional) Additional folder creation parameters.

## Examples

``` r
if (FALSE) { # \dontrun{
vault <- Vault.get_personal_vault()
Vault.create_folder(vault$id, "/My Folder")
} # }
```
