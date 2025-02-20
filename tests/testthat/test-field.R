test_that_with_edp_api("datasetfields", {
  v <- get_test_vault()
  ds <- Dataset_create(v, "dummy.ds")

  #### DatasetField_create
  field <- DatasetField_create(ds,
    name = "name", title = "title", data_type = "float",
    description = "description", ordering = 1
  )

  expect_s3_class(field, "DatasetField")
  expect_identical(as.character(field$dataset_id), ds$id)
  expect_identical(field$name, "name")
  expect_identical(field$title, "title")
  expect_identical(field$data_type, "float")
  expect_identical(field$description, "description")

  #
  field2 <- DatasetField_create(ds, name = "name2", entity_type = "gene", data_type = "string")

  expect_identical(field2$name, "name2")
  expect_identical(field2$title, "name2")
  expect_identical(field2$data_type, "string")
  expect_identical(field2$description, "")
  expect_identical(field2$entity_type, "gene")

  DatasetField_create(ds, name = "name3", is_hidden = TRUE, data_type = "long")
  DatasetField_create(ds, name = "name4", is_list = TRUE, data_type = "float")
  DatasetField_create(ds, name = "name5", ordering = 2, data_type = "object")

  ### DatasetFields()
  # TODO: replace that bt a sync or a wait with tasks
  if (httptest_is_capture_enabled()) Sys.sleep(30)
  fields <- DatasetFields(ds, all = TRUE)

  expect_s3_class(fields, "DatasetFieldList")
  # NB: this includes the _commit field
  expect_length(fields, 6)



  ### DatasetField()
  field2bis <- DatasetField(field2)

  # N.B: is_valid takes some time to be set. Do not check it.
  field2bis$is_valid <- field2$is_valid
  field2bis$updated_at <- field2$updated_at
  expect_equal(field2bis, field2)

  # by dataset_id and name
  field2ter <- DatasetField(dataset_id = ds, name = "name2")

  field2ter$is_valid <- field2$is_valid
  field2ter$updated_at <- field2$updated_at
  expect_equal(field2ter, field2bis)

  expect_error(DatasetField("does_not_exist"), "not found")
  expect_error(DatasetField(dataset_id = "does/not/exist", name = "bad"), "not found")

  ### methods
  # as.data.frame.DatasetField
  df <- as.data.frame(field)

  expect_s3_class(df, "data.frame")
  expect_true(all(c("data_type", "dataset_id", "description") %in% names(df)))
  expect_equal(nrow(df), 1)

  # print.DatasetField
  expect_output(print(field), "id\\s+name")
  expect_output(print(field), "entity_type")

  #  print.DatasetFieldList
  expect_output(print(fields), "EDP List of 6 DatasetFields")

  ### pager
  # fetch_next
  f1 <- DatasetFields(ds, limit = 2)
  expect_identical(as.data.frame(f1)$name, c("name", "name5"))

  f2 <- fetch_next(f1)
  expect_identical(as.data.frame(f2)$name, c("_commit", "name2"))

  f3 <- fetch_next(f2)
  expect_identical(as.data.frame(f3)$name, c("name3", "name4"))

  f4 <- fetch_next(f3)
  expect_null(f4)

  # fetch_prev
  f1b <- fetch_prev(f2)

  expect_identical(as.data.frame(f1b)$name, as.data.frame(f1)$name)
  expect_null(fetch_prev(f1))
  expect_null(fetch_prev(f1b))

  # fetch_all
  fields2 <- fetch_all(f1)
  expect_identical(as.data.frame(fields2)$name, as.data.frame(fields)$name)

  # pagination
  pagination <- attr(f1, "pagination")
  expect_equal(pagination$page_index, list(index = 1, nb = 3, total = 6, size = 2))

  ### DatasetField_update
  field1 <- DatasetField_update(field, title = "NewTitle")

  expect_s3_class(field1, "DatasetField")
  expect_identical(field1$id, field$id)
  expect_identical(field1$title, "NewTitle")
})



test_that("infer_fields_from_df", {
  infer_fields_from_df <- quartzbio.edp:::infer_fields_from_df

  ### edge cases
  expect_null(infer_fields_from_df(NULL))

  ### standard case

  df <- data.frame(
    logical = TRUE,
    character = "toto",
    numeric = 1,
    integer = 1L,
    factor = factor(1),
    list = list(num = 1, int = 1L, character = "toto"),
    date = Sys.Date(),
    arbitrary = bless("toto", "myclass"),
    stringsAsFactors = FALSE
  )

  fields <- infer_fields_from_df(df)

  expect_true(is.list(fields))
  expect_length(fields, ncol(df))
  expect_identical(names(fields), names(df))
  .test_field <- function(field) {
    all(names(field) %in% c("name", "title", "data_type", "description", "ordering"))
  }
  expect_true(all(sapply(fields, .test_field)))
  expect_identical(
    unlist1(elts(fields, "data_type")),
    c(
      "boolean", "string", "double", "integer", "string", "double",
      "integer", "string", "date", "auto"
    )
  )
})



test_that("create_model_df_from_fields_and_cie", {
  create_model_df_from_fields <- quartzbio.edp:::create_model_df_from_fields

  ### create a fields dummy list
  DATA_TYPES <- c(
    "auto", "boolean", "date", "double", "float", "integer", "long", "object",
    "string", "text", "blob"
  )
  .field <- function(name, title = toupper(name), ordering = NULL, description = "",
                     data_type = DATA_TYPES) {
    list(
      name = name, title = title, description = description, data_type = match.arg(data_type),
      ordering = ordering
    )
  }

  .typefield <- function(type, ordering) {
    .field(name = type, data_type = type, ordering = ordering)
  }
  fields <- mapply(.typefield, DATA_TYPES, seq_along(DATA_TYPES) - 1, SIMPLIFY = FALSE)
  # remove some ordering
  fields$date$ordering <- fields$long$ordering <- NULL
  # add entity type for one filed
  fields$date$entity_type <- "sample_metadata"

  cols <- c(rev(DATA_TYPES), "extra")

  df <- create_model_df_from_fields(cols, fields)

  # ordering: N.B: df is in the opposite order of DATA_TYPES.
  # the reordering has fixed that, except for date, long and extra, that have kept the original order
  expect_identical(
    tolower(names(df)),
    c(
      "auto", "boolean", "double", "float", "integer", "object", "string", "text", "blob",
      "long", "date", "extra"
    )
  )

  # types
  classes <- sapply(df, class)
  names(classes) <- tolower(names(classes))
  expect_identical(
    classes,
    c(
      auto = "character", boolean = "logical", double = "numeric",
      float = "numeric", integer = "integer", object = "list", string = "character",
      text = "character", blob = "character", long = "integer", date = "character",
      extra = "character"
    )
  )

  # titles: all changed but the extra colum
  expect_identical(setdiff(names(df), toupper(names(df))), "extra")
  # attributes
  expect_identical(attr(df, "field_names"), tolower(names(df)))
  t1 <- attr(df, "field_titles")
  t2 <- names(df)
  expect_identical(head(t1, -1), head(t2, -1))
  expect_identical(tail(t1, 1), "extra")

  t1 <- attr(df, "field_entity_types")
  expect_type(t1, "character")
  expect_identical(t1[match("DATE", colnames(df))], "sample_metadata")
  ## when absent - NA
  expect_identical(unique(t1[-match("DATE", colnames(df))]), NA_character_)

  ### format_df_like_model
  model <- df

  .mk_str_col <- function(type, nb) {
    make.unique(replicate(type, n = nb))
  }
  .mkdf <- function(types, nb) {
    lst <- lapply(types, .mk_str_col, nb = nb)
    df <- do.call(cbind.data.frame, lst)
    names(df) <- types

    df
  }

  ###   format_df_like_model()
  format_df_like_model <- quartzbio.edp:::format_df_like_model

  df <- .mkdf(cols, 5)

  expect_warning(df2 <- format_df_like_model(df, model), "NAs introduced by coercion")

  # content
  expect_identical(dim(df2), dim(df))
  comparable_fields <- c("object", "string", "text", "date")
  expect_true(all.equal(df2[, toupper(comparable_fields)],
    df[comparable_fields],
    check.attributes = FALSE
  ))

  # names and ordering
  expect_identical(names(df2), names(model))
  .classes <- function(x) sapply(x, class)
  expect_identical(.classes(df2), .classes(model))

  .field_attrs <- function(x) {
    attrs <- attributes(x)
    attrs[grepl("^field_", names(attrs))]
  }
  expect_identical(.field_attrs(df2), .field_attrs(model))

  ################################# edge cases:
  # empty df
  expect_null(create_model_df_from_fields(NULL, NULL))
  expect_null(create_model_df_from_fields(NULL, fields))
})

test_that("format_df_like_model works for list values", {
  # Test case to test columns values as lists with numerical/integer datatypes
  create_model_df_from_fields <- quartzbio.edp:::create_model_df_from_fields

  ### create a fields dummy list
  DATA_TYPES <- c("string", "double", "integer", "long")

  .field <- function(name, title = toupper(name), ordering = NULL, description = "",
                     data_type = DATA_TYPES) {
    list(
      name = name, title = title, description = description, data_type = match.arg(data_type),
      ordering = ordering
    )
  }

  .typefield <- function(type, ordering) {
    .field(name = type, data_type = type, ordering = ordering)
  }
  fields <- mapply(.typefield, DATA_TYPES, seq_along(DATA_TYPES) - 1, SIMPLIFY = FALSE)
  # remove some ordering
  fields$date$ordering <- fields$long$ordering <- NULL
  # add entity type for one filed
  fields$date$entity_type <- "sample_metadata"

  df <- create_model_df_from_fields(DATA_TYPES, fields)
  model <- df
  create_rows <- function(col) {
    col <- toupper(col)
    rows <- switch(col,
      "STRING" = {
        list1 <- c("a1", "a2", "a3")
        list2 <- c("b1", "b2", "b3")
        list3 <- c("c1", "c2", "c3")
        return(list(list1, list2, list3))
      },
      "DOUBLE" = {
        series <- 1:3
        list1 <- c(series + 1.1)
        list2 <- c(series + 2.2)
        list3 <- c(series + 3.3)
        return(list(list1, list2, list3))
      },
      "INTEGER" = list(c(1:3), c(4:6), c(10:15)),
      "LONG" = {
        series <- 47145481:47145483
        list1 <- c(series + 1)
        list2 <- c(series + 2)
        list3 <- c(series + 3)

        return(list(list1, list2, list3))
      }
    )
    names(rows) <- col
    rows
  }

  # Create a dummy dataframe with numerical list values
  .create_df <- function(cols) {
    column_rows <- lapply(cols, create_rows)
    names(column_rows) <- cols

    df <- data.frame(
      matrix(NA,
        nrow = length(column_rows[[1]]),
        ncol = length(column_rows)
      ),
      stringsAsFactors = FALSE
    )
    colnames(df) <- names(column_rows)

    for (col_name in names(column_rows)) {
      df[[col_name]] <- column_rows[[col_name]]
    }
    df
  }

  new_df <- .create_df(DATA_TYPES)

  format_df_like_model <- quartzbio.edp:::format_df_like_model
  df2 <- format_df_like_model(new_df, model)

  expect_identical(dim(df2), dim(new_df))
  # Check correct class assignment when row values are list
  expect_identical(class(df2[[2]]), "list")
  expect_identical(class(df2[[2]][[1]]), "numeric")
  expect_identical(class(df2[[3]][[1]]), "integer")
  expect_identical(class(df2[[4]][[1]]), "integer")
})


test_that("format_df_with_fields", {
  format_df_with_fields <- quartzbio.edp:::format_df_with_fields

  DATA_TYPES <- c(
    "auto", "boolean", "date", "double", "float", "integer", "long", "object",
    "string", "text", "blob"
  )
  .field <- function(name, title = toupper(name), ordering = NULL, description = NULL,
                     data_type = DATA_TYPES) {
    list(
      name = name, title = title, description = description, data_type = match.arg(data_type),
      ordering = ordering
    )
  }

  .typefield <- function(type, ordering) {
    .field(name = type, data_type = type, ordering = ordering)
  }
  fields <- mapply(.typefield, DATA_TYPES, seq_along(DATA_TYPES) - 1, SIMPLIFY = FALSE)
  # remove some ordering
  fields$date$ordering <- fields$long$ordering <- NULL

  .mk_str_col <- function(type, nb) {
    make.unique(replicate(type, n = nb))
  }
  .mkdf <- function(types, nb) {
    lst <- lapply(types, .mk_str_col, nb = nb)
    df <- do.call(cbind.data.frame, lst)
    names(df) <- types

    df
  }

  ###
  df <- .mkdf(rev(DATA_TYPES), 5)
  # add extra column
  df$extra <- paste0("toto", seq_len(nrow(df)))
  # set some attributes, to check if they are preserved
  attr(df, "preserved") <- TRUE

  # we coerce strings to numerics, booleans --> warnings
  expect_warning(df2 <- format_df_with_fields(df, fields), "NAs introduced by coercion")

  # ordering: N.B: df is in the opposite order of DATA_TYPES.
  # the reordering has fixed that, except for date, long and extra, that have kept the original order
  expect_identical(
    tolower(names(df2)),
    c(
      "auto", "boolean", "double", "float", "integer", "object", "string", "text", "blob",
      "long", "date", "extra"
    )
  )

  # types
  classes <- sapply(df2, class)
  names(classes) <- tolower(names(classes))
  expect_identical(
    classes,
    c(
      auto = "character", boolean = "logical", double = "numeric",
      float = "numeric", integer = "integer", object = "list", string = "character",
      text = "character", blob = "character", long = "integer", date = "character",
      extra = "character"
    )
  )

  # titles: all changed but the extra colum
  expect_identical(setdiff(names(df2), toupper(names(df))), "extra")
  # attributes
  expect_identical(attr(df2, "field_names"), tolower(names(df2)))
  t1 <- attr(df2, "field_titles")
  t2 <- names(df2)
  expect_identical(head(t1, -1), head(t2, -1))
  expect_identical(tail(t1, 1), "extra")

  # preserved attributes
  expect_true(attr(df2, "preserved"))

  ### edge cases:
  # empty df
  expect_identical(format_df_with_fields(list2DF(), NULL), list2DF())
})
