# Object.upload_file

Upload a local file to a vault on QuartzBio EDP. The vault path provided
is the parent directory for uploaded file.

## Usage

``` r
Object.upload_file(
  local_path,
  vault_id,
  vault_path,
  filename,
  env = get_connection()
)
```

## Arguments

- local_path:

  The path to the local file

- vault_id:

  The QuartzBio EDP vault ID

- vault_path:

  The remote path in the vault

- filename:

  (optional) The filename for the uploaded file in the vault (default:
  the basename of the local_path)

- env:

  (optional) Custom client environment.

## Examples

``` r
if (FALSE) { # \dontrun{
Object.upload_file("my_file.json.gz", vault$id, "/parent/directory/")
} # }
```
