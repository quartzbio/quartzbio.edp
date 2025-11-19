# shared roxygen params

shared roxygen params

## Arguments

- account_id:

  an Account ID as a string.

- alive:

  whether to select the Tasks that are alive, i.e. not finished or
  failed.

- all:

  whether to fetch all data, by iterating if needed.

- ancestor_id:

  an object ID of an ancestor, for filtering.

- as_data_frame:

  whether to convert the results as a data frame.

- capacity:

  The dataset capacity level (small, medium, or large).

- client_id:

  the client ID for the application.

- commit_mode:

  There are four commit modes that can be selected depending on the
  scenario: append (default), overwrite, upsert, and delete.

- conn:

  a EDP connection object (as a named list or environment)

- dataset_id:

  a Dataset ID as a string

- data_type:

  the data type. one of:

  - auto (the default)

  - boolean - Either True, False, or null

  - date - A string in ISO 8601 format, for example:
    `2017-03-29T14:52:01`

  - double - A double-precision 64-bit IEEE 754 floating point.

  - float - single-precision 32-bit IEEE 754 floating point.

  - integer A signed 32-bit integer with a minimum value of -231 and a
    maximum value of 231-1.

  - long A signed 64-bit integer with a minimum value of -263 and a
    maximum value of 263-1.

  - object A key/value, JSON-like object, similar to a Python
    dictionary.

  - string A valid UTF-8 string up to 32,766 characters in length.

  - text A valid UTF-8 string of any length, indexed for full-text
    search.

  - blob A valid UTF-8 string of any length, not indexed for search.

- depth:

  the depth of the object in the Vault as an integer (0 means root)

- description:

  the description as a string.

- entity_type:

  A valid entity type:

  - dataset - a Dataset ID (510110013133189334)

  - gene - A gene (EGFR)

  - genomic_region - A genomic region (GRCH38-7-55019017-55211628)

  - literature - A PubMed ID (19915526)

  - sample - A sample identifier (TCGA-02-0001)

  - variant - A genomic variant (GRCH38-7-55181378-55181378-T)

- env:

  Custom client environment.

- exclude_fields:

  A list of fields to exclude in the results, as a character vector.

- exclude_group_id:

  a group ID to exclude.

- expression:

  EDP xpressions are Python-like formulas that can be used to pull data
  from datasets, calculate statistics, or run advanced algorithms.

- facets:

  A valid facets objects.

- fields:

  The fields to add.

- field_id:

  a Field object ID.

- file_id:

  a file Object ID.

- filename:

  an Object filename, without the parent folder (e.g. "foo.csv")

- filters:

  a filter expression as a JSON string.

- full_path:

  an Object full path, including the account, vault and path.

- glob:

  a glob (full path with wildcard characters) which searches objects for
  matching paths (case-insensitive).

- include_errors:

  whether to include errors in the output.

- is_list:

  whether the result is expected to be a list.

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- local_path:

  the path of a local file.

- md5:

  a MD5 fingerprint, as a string.

- metadata:

  metadata as a named list.

- mimetype:

  the MIME type of the Object.

- min_distance:

  used in conjuction with the ancestor_id filter to only include objects
  at a minimum distance from the ancestor.

- object_type:

  the type of an object, one of "file", "folder", or "dataset".

- ordering:

  A list of fields to order/sort the results with, as a character
  vector.

- offset:

  the file offset (starts from 0).

- page:

  The number of the page to fetch, as an integer. starts from 1. See
  also `limit`.

- path:

  the path of an object, with the folders (e.g. "/d1/d2/foo.csv").

- parallel:

  whether to parallelize the API calls.

- parent_object_id:

  the ID of the parent of the Object.

- query:

  a string that matches any objects whose path contains that string.

- raw:

  whether to return the raw response.

- records:

  The data to annotate as a data frame.

- regex:

  A regular expression, as a string, to filter the results with.

- size:

  The size of the object.

- status:

  a Task status, one of (running, queued, pending, completed, failed )

- storage_class:

  The Storage class of the vault
  `('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')`
  as a string.

- sync:

  whether to proceed in synchronous mode, i.e to wait for all sub tasks
  to finish before returning.

- tag:

  a single tag as a string.

- tags:

  a list of tags as a character vector.

- target_fields:

  A list of valid dataset fields to create or override in the import, as
  a character vector.

- task_id:

  an (ECS) Task ID as a string.

- url_template:

  A URL template with one or more "value" sections that will be
  interpolated with the field value and displayed as a link in the
  dataset table.

- user_id:

  a user id (or User object) as a string

- vault_id:

  a Vault ID as a string (e.g. "19").

- vault_name:

  a Vault name as a string (e.g. "Public").

- vault_full_path:

  a Vault full path, as a string (e.g. "quartzbio:Public")

- vault_path:

  a Vault path, as a string (e.g. "/d1/d2/foo.csv")

- vault_type:

  the type of vault ('user', 'general') as a string

- workers:

  in parallel mode, the number of concurrent requests to make

- ...:

  Additional query parameters, passed to .request().

  <https://docs.solvebio.com/>
