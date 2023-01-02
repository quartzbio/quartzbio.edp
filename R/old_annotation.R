#' Annotate a data table/frame with additional fields.
#'
#' @inheritParams old_params
#' @export
Annotator.annotate <- function(records, fields, include_errors = FALSE, raw = FALSE,
                               env = get_connection()) {
  params <- list(
    records = records,
    fields = fields,
    include_errors = include_errors
  )
  .request("POST", path = "v1/annotate", query = NULL, body = params, env = env, raw = raw)
}


#' Evaluate a QuartzBio EDP expression.
#'
#' @inheritParams old_params
#' @examples \dontrun{
#' Expression.evaluate("1 + 1", data_type = "integer", is_list = FALSE)
#' }
#' @export
Expression.evaluate <- function(expression, data_type = "string", is_list = FALSE,
                                data = NULL, raw = FALSE, env = get_connection()) {
  params <- list(
    expression = expression,
    data_type = data_type,
    is_list = is_list,
    data = data
  )

  .request("POST", path = "v1/evaluate", query = NULL, body = params, env = env, raw = raw)
}
