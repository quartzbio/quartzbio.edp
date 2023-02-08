
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

#' updates an existing Dataset Field.
#' @inheritParams DatasetField_create
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
  conn = get_connection()) 
{
  params <- preprocess_api_params(exclude = c('conn', 'field'))
  field_id <- id(field_id)

  request_edp_api('PATCH', file.path('v2/dataset_fields', field_id), conn = conn, params = params)
}

#' fetches the fields of a dataset.
#' @export
DatasetFields <- function(dataset_id, limit = NULL, page = NULL, all = FALSE, conn = get_connection()) 
{
  dataset_id <- id(dataset_id)
  params  <- preprocess_api_params()
  all <- params$all
  params$all <- NULL

  lst <- request_edp_api('GET', file.path("v2/datasets", dataset_id, 'fields'), params = params, 
     conn = conn, limit = limit, page = page)
  if (all) lst <- fetch_all(lst)

  names(lst) <- elts(lst, 'name')

  lst
}

#' fetches a field metadata of a dataset by ID or (datasetid, field_name)
#' @export
DatasetField <- function(id = NULL, dataset_id = NULL, name = NULL, conn = get_connection()) 
{
  id <- id(id)
  if (!length(id)) {
    dataset_id <- id(dataset_id)
    .die_unless(.is_nz_string(dataset_id) && .is_nz_string(name), 
      'both "dataset_id" and "name" are required to fetch a DataSetField by name' )
    fields <- DatasetFields(dataset_id, conn = conn)
    field <- fields[[name]]
    .die_if(length(field) == 0, 'could not find a field named "%s"', name)
    return(field)
  }

  request_edp_api('GET', file.path("v2/dataset_fields", id), conn = conn)
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

R_TO_DATA_TYPES = list(
  character = 'string', 
  logical = 'boolean', 
  Date = 'date',
  numeric = 'double',
  integer = 'integer',
  list = 'object',
  factor = 'character'
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
    browser()
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
          if (expected_type == 'numeric') {
            # for some reason as(1L, 'numeric') does not work
            df[[col]] <- as.numeric(df[[col]])
          } else {
            df[[col]] <- as(df[[col]], expected_type)
          }
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
    attr(df, 'field_data_types') <- .elts(fields, 'data_type')
  }

  df
}

# create a fields list suitable to be used to create or update a Dataset
# from a df
infer_fields_from_df <- function(df) {
  if (!length(df)) return(NULL)
  classes <- unlist1(lapply(df, class))
  df_names <- names(df)

  .field <- function(i) {
    colname <- df_names[i]
    type <- class(df[[i]])[1]
    data_type <- R_TO_DATA_TYPES[[type]]
    if (!.is_nz_string(data_type)) data_type <- 'auto'

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
  cols <- c('id', 'name',  'title', 'description', 'data_type', 'ordering', 'is_hidden')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

