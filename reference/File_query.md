# queries the content of a file.

The file has to be parsable by EDP. Otherwise you can use
[`File_download()`](https://quartzbio.github.io/quartzbio.edp/reference/File_download.md)

## Usage

``` r
File_query(
  id,
  filters = NULL,
  limit = 10000,
  offset = NULL,
  all = FALSE,
  conn = get_connection()
)
```

## Arguments

- id:

  a File ID

- filters:

  a filter expression as a JSON string.

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- offset:

  the file offset (starts from 0).

- all:

  whether to fetch all data, by iterating if needed.

- conn:

  a EDP connection object (as a named list or environment)
