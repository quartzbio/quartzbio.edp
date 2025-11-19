# uploads a file Upload a file to a QuartzBio vault. Automatically uses multipart upload for files larger than the multipart_threshold. multipart_threshold (int): File size threshold for multipart upload (default: 64MB) multipart_chunksize (int): Size of each upload part (default: 64MB)

uploads a file Upload a file to a QuartzBio vault. Automatically uses
multipart upload for files larger than the multipart_threshold.
multipart_threshold (int): File size threshold for multipart upload
(default: 64MB) multipart_chunksize (int): Size of each upload part
(default: 64MB)

## Usage

``` r
File_upload(
  vault_id,
  local_path,
  vault_path,
  mimetype = mime::guess_type(local_path),
  conn = get_connection()
)
```

## Arguments

- vault_id:

  a Vault ID as a string (e.g. "19").

- local_path:

  the path of a local file.

- vault_path:

  a Vault path, as a string (e.g. "/d1/d2/foo.csv")

- mimetype:

  the MIME type of the Object.

- conn:

  a EDP connection object (as a named list or environment)
