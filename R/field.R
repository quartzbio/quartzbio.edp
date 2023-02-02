# TODO:
# function to infer fields definitions from a df
# function to apply/create fields (with option to only if not set)


# data_type 	string 	A valid data type (see below).
# description 	string 	Describes the contents of the field.
# entity_type 	string 	A valid entity type (see below).
# expression 	string 	A valid expression.
# is_hidden 	boolean 	Set to True if the field should be excluded by default from the UI.
# is_list 	boolean 	Set to True if multiple values are stored as a list.
# name 	string 	The "low-level" field name, used in JSON formatted records.
# ordering 	integer 	The order in which this column appears when retrieving data from the dataset. Order is 0-based. Default is 0
# title 	string 	The field's display name, shown in the UI and in CSV/Excel exports.
# url_template 	string 	A URL template with one or more "{value}" sections that will be interpolated with the field value and displayed as a link in the dataset table

#' creates a new Dataset Field.
#' @inheritParams params
#' @param title   The field's display name, shown in the UI and in CSV/Excel exports, as a string
#' @param ordering  The order in which this column appears when retrieving data from the dataset. 
#'                  Order is 0-based. Default is 0.
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
  conn = get_connection()) 
{
  dataset_id <- id(dataset_id)
  params <- preprocess_api_params()
  request_edp_api('POST', 'v2/dataset_fields', conn = conn, params = params)
}


#' fetches the fields of a dataset.
#' @export
DatasetFields <- function(dataset_id, limit = NULL, page = NULL, all = FALSE, conn = get_connection()) 
{
  dataset_id <- id(dataset_id)
  params  <- preprocess_api_params()
  all <- params$all
  params$all <- NULL

  df <- request_edp_api('GET', file.path("v2/datasets", dataset_id, 'fields'), params = params, 
     conn = conn, limit = limit, page = page)
  if (all) df <- fetch_all(df)

  df
}


DATA_TYPES_TO_R = list(
  auto = 'character', 
  boolean = 'logical', 
  date = 'character',
  double = 'numeric',
  float = 'numeric',
  integer = 'integer',
  long = 'integer',
  object = 'list', 
  string = 'character',
  text = 'character',
  blob = 'character'
)
# actions:
# - order columns based on ordering
# - type the data frame using the field types
# - set the column names to the titles
# - store the names, titles and descriptions as attributes
format_df_with_fields <- function(df, fields, 
  titles = TRUE, 
  types = TRUE, 
  ordering = TRUE, 
  attributes = TRUE) 
{
  .elts <- function(lst, name) unname(sapply(lst, getElement, name))
 
  # the fields may not cover all columns, e.g. the _id, _commit ones
  # we create default dummy fields for those to simplify the processing
  .field  <- function(name) {
    list(name = name, title = name, description = '', data_type = NULL, ordering = NULL)
  }

  field_names <- .elts(fields, 'name')
  df_names <- names(df)

  missings <- setdiff(df_names, field_names)
  missing_fields <- lapply(missings, .field)
  fields <- c(fields, missing_fields)
  names(fields) <- c(field_names, missings)

  fields <- fields[df_names]


  # !! must be first
  if (ordering) {
    # use ordering if set, otherwise the current ordering
    orderings <- .elts(fields, 'ordering')
    missings <- lengths(orderings) == 0

    if (any(missings)) {
      maxo <- if (all(missings)) 0 else max(unlist(orderings, recursive = FALSE), na.rm = TRUE) + 1
      missing_orderings <- seq.int(maxo, length.out = sum(missings))
      orderings[missings] <- missing_orderings
    }
    ordering <- order(unlist(orderings, recursive = FALSE))
    fields <- fields[ordering]
    df <- df[ordering]
  }

  if (types) {
    df_names <- names(df)
    for (col in df_names) {
      ftype <- fields[[col]]$data_type
      if (length(ftype)) {
        df_type <- class(df[[col]])[1]
        expected_type <- DATA_TYPES_TO_R[[ftype]]
        # defensive programming
        .die_unless(.is_nz_string(expected_type), 'unknown data_type "%s"', ftype)

        if (!inherits(df[[col]], expected_type)) {
          df[[col]] <- as(df[[col]], expected_type)
        }
      }
    }
  }

  if (titles) {
    names(df) <- .elts(fields, 'title')
  }

  if (attributes) {
    attr(df, 'field_names') <-  .elts(fields, 'name')
    attr(df, 'field_titles') <- .elts(fields, 'title')
    attr(df, 'field_descriptions') <- .elts(fields, 'description')
  }

  df
}


### 
### DatasetField methods

#' @export
as.data.frame.DatasetField <- function (x,  ...) {
  y <- unclass(x)
  y[lengths(y) == 0] <- NA

  as.data.frame.list(y)
}

#' @export
print.DatasetField <- function(x, ...) {
  df <- as.data.frame(x)

  cols <- c('id', 'name',  'title', 'description',  'ordering', 'is_hidden')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

#' @export
print.DatasetFieldList <- function(x, ...) {
  cat('EDP List of' , length(x), 'DatasetFields\n')

  df <- as.data.frame(x)
  cols <- c('id', 'name',  'title', 'description',  'ordering', 'is_hidden')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

