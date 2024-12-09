#' shared roxygen params
#'
#' @param account_id                an Account ID as a string.
#' @param alive                     whether to select the Tasks that are alive, i.e. not finished
#'                                  or failed.
#' @param all                       whether to fetch all data, by iterating if needed.
#' @param ancestor_id               an object ID of an ancestor, for filtering.
#' @param as_data_frame             whether to convert the results as a data frame.
#' @param capacity                  The dataset capacity level (small, medium, or large).
#' @param client_id                 the client ID for the application.
#' @param commit_mode               There are four commit modes that can be selected depending on the scenario:
#'                                   append (default), overwrite, upsert, and delete.
#' @param conn                      a EDP connection object (as a named list or environment)
#' @param dataset_id                a Dataset ID as a string
#' @param data_type                 the data type. one of:
#' * auto (the default)
#' * boolean - Either True, False, or null
#' * date - A string in ISO 8601 format, for example: `2017-03-29T14:52:01`
#' * double - A double-precision 64-bit IEEE 754 floating point.
#' * float - single-precision 32-bit IEEE 754 floating point.
#' * integer 	A signed 32-bit integer with a minimum value of -231 and a maximum value of 231-1.
#' * long 	A signed 64-bit integer with a minimum value of -263 and a maximum value of 263-1.
#' * object 	A key/value, JSON-like object, similar to a Python dictionary.
#' * string 	A valid UTF-8 string up to 32,766 characters in length.
#' * text 	A valid UTF-8 string of any length, indexed for full-text search.
#' * blob 	A valid UTF-8 string of any length, not indexed for search.
#' @param depth                     the depth of the object in the Vault as an integer (0 means root)
#' @param description               the description as a string.
#' @param entity_type               A valid entity type:
#' * dataset - a Dataset ID (510110013133189334)
#' * gene - A gene (EGFR)
#' * genomic_region - A genomic region (GRCH38-7-55019017-55211628)
#' * literature - A PubMed ID (19915526)
#' * sample - A sample identifier (TCGA-02-0001)
#' * variant - A genomic variant (GRCH38-7-55181378-55181378-T)
#' @param env                       Custom client environment.
#' @param exclude_fields            A list of fields to exclude in the results, as a character vector.
#' @param exclude_group_id          a group ID to exclude.
#' @param expression                EDP xpressions are Python-like formulas that can be used to pull
#'                                  data from datasets, calculate statistics, or run advanced algorithms.
#' @param facets                    A valid facets objects.
#' @param fields                    The fields to add.
#' @param field_id                  a Field object ID.
#' @param file_id                   a file Object ID.
#' @param filename                  an Object filename, without the parent folder (e.g. "foo.csv")
#' @param filters                   a filter expression as a JSON string.
#' @param full_path                 an Object full path, including the account, vault and path.
#' @param glob                      a glob (full path with wildcard characters) which searches
#'                                  objects for matching paths (case-insensitive).
#' @param include_errors            whether to include errors in the output.
#' @param is_list                   whether the result is expected to be a list.
#' @param limit                     The maximum number of elements to fetch, as an integer.
#'                                  See also `page`.
#' @param local_path                the path of a local file.
#' @param md5                       a MD5 fingerprint, as a string.
#' @param metadata                  metadata as a named list.
#' @param mimetype                  the MIME type of the Object.
#' @param min_distance              used in conjuction with the ancestor_id filter to only include
#'                                   objects at a minimum distance from the ancestor.
#' @param object_type               the type of an object, one of  "file", "folder", or "dataset".
#' @param ordering                  A list of fields to order/sort the results with, as a character vector.
#' @param offset                    the file offset (starts from 0).
#' @param page                      The number of the page to fetch, as an integer. starts from 1.
#'                                  See also `limit`.
#' @param path                      the path of an object, with the folders (e.g. "/d1/d2/foo.csv").
#' @param parallel                  whether to parallelize the API calls.
#' @param parent_object_id          the ID of the parent of the Object.
#' @param query                     a string that matches any objects whose path contains that string.
#' @param raw                       whether to return the raw response.
#' @param records                   The data to annotate as a data frame.
#' @param regex                     A regular expression, as a string, to filter the results with.
#' @param size                      The size of the object.
#' @param status                    a Task status, one of (
#' ```{r,echo=FALSE, results='asis'}
#' cat(TASK_STATUS, sep = ', ')
#' ```
#' )
#' @param storage_class             The Storage class of the vault `('Standard', 'Standard-IA',
#'                                   'Essential', 'Temporary', 'Performance', 'Archive')` as a string.
#' @param sync                      whether to proceed in synchronous mode, i.e to wait for all
#'                                  sub tasks to finish before returning.
#' @param tag                       a single tag as a string.
#' @param tags                      a list of tags as a character vector.
#' @param target_fields             A list of valid dataset fields to create or override in the import,
#'                                  as a character vector.
#' @param task_id                   an (ECS) Task ID as a string.
#' @param url_template              A URL template with one or more "value" sections that will be
#'                                  interpolated with the field value and displayed as a link
#'                                  in the dataset table.
#' @param user_id                   a user id (or User object) as a string
#' @param vault_id                  a Vault ID as a string (e.g. "19").
#' @param vault_name                a Vault name as a string (e.g. "Public").
#' @param vault_full_path           a Vault full path, as a string (e.g. "quartzbio:Public")
#' @param vault_path                a Vault path, as a string (e.g. "/d1/d2/foo.csv")
#' @param vault_type                the type of vault ('user', 'general') as a string
#' @param workers                   in parallel mode, the number of concurrent requests to make
#' @param ...                       Additional query parameters, passed to .request().
#'
#' @references \url{https://docs.solvebio.com/}
#'
#' @name params
NULL

#' shared old roxygen params
#'
#' @param client_id                 The client ID for the application.
#' @param conn                      a EDP connection object (as a named list or environment)
#' @param data                      TODO
#' @param data_type                 The data type to cast the expression result.
#' @param env                       Custom client environment.
#' @param expression                The EDP expression string.
#' @param fields                    The fields to add.
#' @param include_errors            whether to include errors in the output.
#' @param is_list                   whether the result is expected to be a list.
#' @param raw                       whether to return the raw response.
#' @param records                   The data to annotate as a data frame.
#' @param ...                       Additional query parameters, passed to .request().
#'
#' @references \url{https://docs.solvebio.com/}
#'
#' @name old_params
NULL


TASK_STATUS <- c("running", "queued", "pending", "completed", "failed")
TASK_STATUS_ALIVE <- c("pending", "queued", "running")
