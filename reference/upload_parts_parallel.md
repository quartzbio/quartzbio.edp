# Function to upload parts in parallel

Function to upload parts in parallel

## Usage

``` r
upload_parts_parallel(
  local_path,
  part_tasks,
  object,
  num_processes,
  conn = get_connection(),
  ...
)
```

## Arguments

- local_path:

  Path of file in local

- part_tasks:

  File parts to be uploaded

- object:

  File object created

- num_processes:

  Number of parallel workers for multipart upload

- conn:

  Valid EDP connection

- ...:

  Arguments passed on to
  [`Objects`](https://quartzbio.github.io/quartzbio.edp/reference/Objects.md)

  `ancestor_id`

  :   an object ID of an ancestor, for filtering.

  `depth`

  :   the depth of the object in the Vault as an integer (0 means root)

  `filename`

  :   an Object filename, without the parent folder (e.g. "foo.csv")

  `glob`

  :   a glob (full path with wildcard characters) which searches objects
      for matching paths (case-insensitive).

  `limit`

  :   The maximum number of elements to fetch, as an integer. See also
      `page`.

  `min_distance`

  :   used in conjuction with the ancestor_id filter to only include
      objects at a minimum distance from the ancestor.

  `object_type`

  :   the type of an object, one of "file", "folder", or "dataset".

  `page`

  :   The number of the page to fetch, as an integer. starts from 1. See
      also `limit`.

  `path`

  :   the path of an object, with the folders (e.g. "/d1/d2/foo.csv").

  `query`

  :   a string that matches any objects whose path contains that string.

  `regex`

  :   A regular expression, as a string, to filter the results with.

  `storage_class`

  :   The Storage class of the vault
      `('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')`
      as a string.

  `tag`

  :   a single tag as a string.

  `vault_id`

  :   a Vault ID as a string (e.g. "19").

  `vault_name`

  :   a Vault name as a string (e.g. "Public").

  `vault_full_path`

  :   a Vault full path, as a string (e.g. "quartzbio:Public")
