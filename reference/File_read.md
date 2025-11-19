# convenience function to download a file into memory, just a wrapper over File_download()

convenience function to download a file into memory, just a wrapper over
File_download()

## Usage

``` r
File_read(file_id, local_path = tempfile(), conn = get_connection(), ...)
```

## Arguments

- file_id:

  a file Object ID.

- local_path:

  where to download the file. Used for testing purposes.

- conn:

  a EDP connection object (as a named list or environment)

- ...:

  passed to File_download()

## Value

the file content
