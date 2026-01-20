# fetches a list of datasets.

fetches a list of datasets.

## Usage

``` r
Datasets(
  vault_id = NULL,
  vault_name = NULL,
  vault_full_path = NULL,
  filename = NULL,
  path = NULL,
  object_type = NULL,
  depth = NULL,
  query = NULL,
  regex = NULL,
  glob = NULL,
  ancestor_id = NULL,
  min_distance = NULL,
  tag = NULL,
  storage_class = NULL,
  limit = NULL,
  page = NULL,
  conn = get_connection()
)
```

## Arguments

- vault_id:

  a Vault ID as a string (e.g. "19").

- vault_name:

  a Vault name as a string (e.g. "Public").

- vault_full_path:

  a Vault full path, as a string (e.g. "quartzbio:Public")

- filename:

  an Object filename, without the parent folder (e.g. "foo.csv")

- path:

  the path of an object, starting from the vault's root directory. The
  path must include all intermediate folders and end with the object’s
  name (e.g. "/d1/d2/foo.csv" or "/d1/d2/").

- object_type:

  the type of an object, one of "file", "folder", "dataset" or
  "shortcut".

- depth:

  the depth of the object in the Vault as an integer (0 means root)

- query:

  a string that matches any objects whose path contains that string.

- regex:

  A regular expression, as a string, to filter the results with.

- glob:

  a glob (full path with wildcard characters) which searches objects for
  matching paths (case-insensitive).

- ancestor_id:

  an object ID of an ancestor, for filtering.

- min_distance:

  used in conjuction with the ancestor_id filter to only include objects
  at a minimum distance from the ancestor.

- tag:

  a single tag as a string.

- storage_class:

  The Storage class of the vault
  `('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')`
  as a string.

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- page:

  The number of the page to fetch, as an integer. starts from 1. See
  also `limit`.

- conn:

  a EDP connection object (as a named list or environment)
