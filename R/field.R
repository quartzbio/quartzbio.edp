#' creates a new Dataset Field.
#' @inheritParams params
#' @param name          The name of the field
#' @param title         The field's display name, shown in the UI and in CSV/Excel exports, as a string
#' @param is_hidden     whether the field should be hidden from the UI.
#' @param ordering      The order in which this column appears when retrieving data from the dataset.
#'                      Order is 0-based. Default is 0.
#' @export
DatasetField_create <- function(
    dataset_id,
    data_type,
    name,
    title = NULL,
    description = NULL,
    ordering = NULL,
    entity_type = NULL,
    expression = NULL,
    is_hidden = NULL,
    is_list = NULL,
    url_template = NULL,
    conn = get_connection()) {
  dataset_id <- id(dataset_id)
  params <- preprocess_api_params()
  request_edp_api("POST", "v2/dataset_fields", conn = conn, params = params)
}

#' updates an existing Dataset Field.
#'
#' @inheritParams params
#' @inheritParams DatasetField_create
#' @return a DatasetField object
#' @export
DatasetField_update <- function(
    field_id,
    data_type = NULL,
    title = NULL,
    description = NULL,
    ordering = NULL,
    entity_type = NULL,
    expression = NULL,
    is_hidden = NULL,
    is_list = NULL,
    url_template = NULL,
    conn = get_connection()) {
  params <- preprocess_api_params(exclude = c("conn", "field"))
  field_id <- id(field_id)

  request_edp_api("PATCH", file.path("v2/dataset_fields", field_id), conn = conn, params = params)
}

#' fetches the fields of a dataset.
#' @inherit params
#' @return a DatasetFieldList object
#' @export
DatasetFields <- function(dataset_id, limit = NULL, page = NULL, all = FALSE, conn = get_connection(), ...) {
  dataset_id <- id(dataset_id)
  params <- preprocess_api_params()
  all <- params$all
  params$all <- NULL

  lst <- request_edp_api("GET", file.path("v2/datasets", dataset_id, "fields"),
    params = params,
    conn = conn, limit = limit, page = page, ...
  )
  if (!length(lst)) {
    return(NULL)
  }

  if (all) lst <- fetch_all(lst)

  names(lst) <- elts(lst, "name")

  lst
}

#' fetches a field metadata of a dataset by ID or (datasetid, field_name)
#' @inheritParams DatasetField_create
#' @inheritParams params
#' @return a DatasetField object
#' @export
DatasetField <- function(field_id = NULL, dataset_id = NULL, name = NULL, conn = get_connection()) {
  id <- id(field_id)
  if (!length(id)) {
    dataset_id <- id(dataset_id)
    .die_unless(
      .is_nz_string(dataset_id) && .is_nz_string(name),
      'both "dataset_id" and "name" are required to fetch a DataSetField by name'
    )
    fields <- DatasetFields(dataset_id, conn = conn)
    field <- fields[[name]]
    .die_if(length(field) == 0, 'field not foundn: "%s"', name)
    return(field)
  }

  field <- request_edp_api("GET", file.path("v2/dataset_fields", id), conn = conn) %IF_EMPTY_THEN%
    .die('field id "%s" not found', id)

  field
}


DATA_TYPES_TO_R <- list(
  auto = "character",
  boolean = "logical",
  date = "character",
  double = "numeric",
  float = "numeric",
  integer = "integer",
  long = "integer",
  object = "list",
  string = "character",
  text = "character",
  blob = "character"
)

R_TO_DATA_TYPES <- list(
  character = "string",
  logical = "boolean",
  Date = "date",
  numeric = "double",
  integer = "integer",
  list = "object",
  factor = "string"
)



# create a model data frame (empty) from a list of colum names and some meta data fields
# actions:
# - order columns based on ordering
# - type the data frame using the field types
# - set the column names to the titles
# - store the names, titles and descriptions as attributes
create_model_df_from_fields <- function(
    cols, fields,
    titles = TRUE,
    ordering = TRUE) {
  if (.empty(cols)) {
    return(NULL)
  }

  .elts <- function(lst, name) unname(sapply(lst, getElement, name))

  # the fields may not cover all columns, e.g. the _id, _commit ones
  # we create default dummy fields for those to simplify the processing
  .field <- function(name) {
    list(name = name, title = name, description = "", data_type = "string", ordering = NULL)
  }

  field_names <- .elts(fields, "name")

  missings <- setdiff(cols, field_names)
  missing_fields <- lapply(missings, .field)
  fields <- c(fields, missing_fields)
  names(fields) <- c(field_names, missings)

  # N.B: reorder by cols
  fields <- fields[cols]

  # must be first
  if (ordering) {
    # use ordering if set, otherwise the current ordering
    orderings <- .elts(fields, "ordering")
    missings <- lengths(orderings) == 0

    if (any(missings)) {
      maxo <- if (all(missings)) 0 else max(unlist(orderings, recursive = FALSE), na.rm = TRUE) + 1
      missing_orderings <- seq.int(maxo, length.out = sum(missings))
      orderings[missings] <- missing_orderings
    }
    ordering <- order(unlist(orderings, recursive = FALSE))
    fields <- fields[ordering]
    cols <- names(fields)
  }

  model <- vector(mode = "list", length = length(cols))
  types <- .elts(fields, "data_type")
  r_types <- DATA_TYPES_TO_R[types]
  df <- lapply(r_types, vector)

  names(df) <- if (titles) .elts(fields, "title") else cols
  # crude way to convert to data frame, but it PRESERVES list columns
  class(df) <- "data.frame"

  for (x in c("name", "title", "description", "data_type")) {
    attr(df, paste0("field_", x, "s")) <- .elts(fields, x)
  }

  # in case some are NULL
  entity_types <- .elts(fields, "entity_type")
  entity_types[sapply(entity_types, is.null)] <- NA_character_
  attr(df, "field_entity_types") <- unlist(entity_types)

  df
}

# format a data frame like a model data frame: i.e copy
# - the columns order
# - the field types
# - the column names
# - the "field_" attributes
# the "model" data frame is assumed to have been generated either by create_model_df_from_fields()
# or by this very same function
# N.B: the mapping of columns between the df and the model is performed using
# the "field_names" attribute of the model
# N.B 2: tested with create_model_df_from_fields()
# N.B 3: both data franes must have the same fields
format_df_like_model <- function(df, model) {
  ### mapping
  field_names <- attr(model, "field_names")
  if (.empty(field_names)) {
    # model has no field information --> it is not a true model, nothing to do
    return(df)
  }

  .die_unless(setequal(names(df), field_names), "different fields")

  # backup attributes
  backup_attrs <- attributes(df)

  ### reorder like the model
  idx <- match(field_names, names(df))
  df <- df[, idx, drop = FALSE]

  ### set field types
  for (i in seq_along(df)) {
    if (class(df[[i]]) != class(model[[i]])) {
      class(df[[i]]) <- class(model[[i]])
    }
  }

  ### set titles/column names
  names(df) <- names(model)

  # set field attributes
  attrs <- attributes(model)
  attrs <- attrs[grepl("^field_", names(attrs))]
  for (attname in names(attrs)) {
    attr(df, attname) <- attrs[[attname]]
  }

  # fetch attributes from backup which are not set
  attrs <- attributes(df)
  lost <- setdiff(names(backup_attrs), names(attrs))
  for (attr_name in lost) {
    attr(df, attr_name) <- backup_attrs[[attr_name]]
  }

  df
}

# actions:
# - order columns based on ordering
# - type the data frame using the field types
# - set the column names to the titles
# - store the names, titles and descriptions as attributes
format_df_with_fields <- function(
    df, fields,
    titles = TRUE,
    types = TRUE,
    ordering = TRUE,
    attributes = TRUE) {
  if (ncol(df) == 0) {
    return(df)
  }
  model <- create_model_df_from_fields(names(df), fields)
  format_df_like_model(df, model)
}

# create a fields list suitable to be used to create or update a Dataset
# from a df
infer_fields_from_df <- function(df) {
  if (!length(df)) {
    return(NULL)
  }
  classes <- unlist1(lapply(df, class))
  df_names <- names(df)

  .field <- function(i) {
    colname <- df_names[i]
    type <- class(df[[i]])[1]
    data_type <- R_TO_DATA_TYPES[[type]]
    if (!.is_nz_string(data_type)) data_type <- "auto"

    list(
      name = colname,
      title = colname,
      data_type = data_type,
      description = NULL,
      ordering = i - 1
    )
  }
  fields <- lapply(seq_len(ncol(df)), .field)
  names(fields) <- names(df)

  fields
}

###
### DatasetField methods

#' @export
as.data.frame.DatasetField <- function(x, ...) {
  y <- unclass(x)
  y[lengths(y) == 0] <- NA

  as.data.frame.list(y)
}

#' @export
print.DatasetField <- function(x, ...) {
  df <- as.data.frame(x)

  cols <- c("id", "name", "title", "description", "ordering", "is_hidden", "entity_type")
  cols <- intersect(cols, names(df))
  df <- df[cols]

  print(df)
}

#' @export
print.DatasetFieldList <- function(x, ...) {
  cat("EDP List of", length(x), "DatasetFields\n")

  df <- as.data.frame(x)
  cols <- c("id", "name", "title", "description", "data_type", "ordering", "is_hidden", "entity_type")
  cols <- intersect(cols, names(df))
  df <- df[cols]

  print(df)
}
