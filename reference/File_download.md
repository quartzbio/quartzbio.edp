# utility function that downloads an EDP File into a local file

utility function that downloads an EDP File into a local file

## Usage

``` r
File_download(file_id, local_path, conn = get_connection(), ...)
```

## Arguments

- file_id:

  a file Object ID.

- local_path:

  the path of a local file.

- conn:

  a EDP connection object (as a named list or environment)

- ...:

  passed to File_download_content()

## Value

the response
