# fetches the download URL of a file.

This URL can then be used to download the file using any HTTP client,
such as utils::download.file()

## Usage

``` r
File_get_download_url(file_id, conn = get_connection())
```

## Arguments

- file_id:

  a file Object ID.

- conn:

  a EDP connection object (as a named list or environment)

## Value

the download URL as a string
