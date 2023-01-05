#' shared roxygen params
#' 
#' @param account_id                an Account ID.
#' @param client_id                 the client ID for the application.
#' @param conn                      a EDP connection object (as a named list or environment)
#' @param data_type                 the data type to cast the expression result.
#' @param description               the description as a string.
#' @param env                       Custom client environment.
#' @param exclude_group_id          a group ID to exclude. 
#' @param fields                    The fields to add.
#' @param include_errors            whether to include errors in the output.
#' @param is_list                   whether the result is expected to be a list.
#' @param limit                     The maximum number of elements to fetch, as an integer. 
#'                                  See also `page`.
#' @param page                      The number of the page to fetch, as an integer. starts from 1.
#'                                  See also `limit`.
#' @param metadata                  metadata as a named list.
#' @param raw                       whether to return the raw response.
#' @param records                   The data to annotate as a data frame.
#' @param storage_class             The Storage class of the vault `('Standard', 'Standard-IA',
#'                                   'Essential', 'Temporary', 'Performance', 'Archive')` as a string.
#' @param tag                       a tag as a string.
#' @param tags                      a list of tags as a character vector.
#' @param user_id                   a user id (or User object) as a string
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
