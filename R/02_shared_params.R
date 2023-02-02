#' shared roxygen params
#' 
#' @param account_id                an Account ID as a string.
#' @param all                       whether to fetch all data, by iterating if needed.
#' @param ancestor_id               an object ID of an ancestor, for filtering. 
#' @param client_id                 the client ID for the application.
#' @param commit_mode               There are four commit modes that can be selected depending on the scenario:
#'                                   append (default), overwrite, upsert, and delete. 
#' @param conn                      a EDP connection object (as a named list or environment)
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
#' @param env                       Custom client environment.
#' @param exclude_group_id          a group ID to exclude. 
#' @param fields                    The fields to add.
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
#' @param offset                    the file offset (starts from 0).
#' @param page                      The number of the page to fetch, as an integer. starts from 1.
#'                                  See also `limit`.
#' @param path                      the path of an object, with the folders (e.g. "/d1/d2/foo.csv").
#' @param parent_object_id          the ID of the parent of the Object.
#' @param query                     a string that matches any objects whose path contains that string.
#' @param raw                       whether to return the raw response.
#' @param records                   The data to annotate as a data frame.
#' @param regex                     A regular expression, as a string, to filter the results with.
#' @param size                      The size of the object.
#' @param storage_class             The Storage class of the vault `('Standard', 'Standard-IA',
#'                                   'Essential', 'Temporary', 'Performance', 'Archive')` as a string.
#' @param tag                       a single tag as a string.
#' @param tags                      a list of tags as a character vector.
#' @param user_id                   a user id (or User object) as a string
#' @param vault_id                  a Vault ID as a string (e.g. "19").
#' @param vault_name                a Vault name as a string (e.g. "Public").
#' @param vault_full_path           a Vault full path, as a string (e.g. "quartzbio:Public")
#' @param vault_path                a Vault path, as a string (e.g. "/d1/d2/foo.csv")
#' @param vault_type                the type of vault ('user', 'general') as a string
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
