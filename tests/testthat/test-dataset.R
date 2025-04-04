test_that_with_edp_api("datasets", {
  v <- get_test_vault()

  ### Dataset_create
  # minimal
  ds <- Dataset_create(v, "/toto/titi/my_dataset")

  expect_s3_class(ds, "Dataset")
  expect_type(ds, "list")
  expect_identical(ds$path, "/toto/titi/my_dataset")

  # all params
  ds2 <- Dataset_create(v, "/toto/titi/my_dataset2",
    description = "description",
    metadata = list(DEV = TRUE), tags = list("QBP", "EDP"), storage_class = "Temporary",
    capacity = "small"
  )

  expect_identical(ds2$path, "/toto/titi/my_dataset2")
  expect_identical(ds2$description, "description")
  expect_identical(ds2$metadata, list(DEV = TRUE))
  expect_identical(ds2$tags, list("QBP", "EDP"))
  expect_identical(ds2$storage_class, "Temporary")

  ### Datasets()
  lst <- Datasets(v)

  expect_s3_class(lst, "DatasetList")
  expect_length(lst, 2)
  expect_s3_class(lst[[1]], "Dataset")

  ### Dataset()
  # by id
  ds2bis <- Dataset(ds2)

  expect_s3_class(ds2bis, "Dataset")
  expect_identical(ds2bis$id, ds2$id)

  # by path and vault
  ds2ter <- Dataset(vault_id = v, path = "/toto/titi/my_dataset2")
  expect_equal(ds2ter, ds2bis)

  expect_error(Dataset("does_not_exist"), "entity not found")
  expect_error(Dataset(full_path = "does/not/exist"), "entity not found")

  ### methods
  # print.DatasetList
  expect_output(print(lst), "EDP List of 2 Datasets")

  ### import
  # records
  records <- list(
    list(gene = "CFTR", importance = 1, sample_count = 2104),
    list(gene = "BRCA2", importance = 1, sample_count = 1391),
    list(gene = "CLIC2", importance = 5, sample_count = 14)
  )
  res <- Dataset_import(ds, records = records, sync = httptest_is_capture_enabled())

  expect_s3_class(res, "DatasetImport")
  # check content
  df <- Dataset_query(ds)
  df2 <- do.call(rbind.data.frame, records)

  expect_equal(df[names(df2)], df2, ignore_attr = TRUE)

  ### df
  # delete(ds2);ds2 <- Dataset_create(v, "/toto/titi/my_dataset2")
  dfi <- data.frame(
    logical = TRUE,
    character = "toto",
    numeric = 1,
    integer = 1L,
    factor = factor("level1"),
    # list = list(num = 1, int = 1L, character = 'toto'),
    date = as.Date(as.POSIXlt("2023-02-13")),
    arbitrary = bless("toto", "myclass"),
    stringsAsFactors = FALSE
  )
  res <- Dataset_import(ds2, df = dfi, sync = httptest_is_capture_enabled())
  df <- Dataset_query(ds2)

  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 1)

  # check the types,  type mappings does not support everything yet
  # currently exported as character. could be changed
  expect_identical(class(df$date), "character")
  df$date <- as.Date(df$date)
  # idem for factors
  expect_identical(class(df$factor), "character")
  df$factor <- factor(df$factor)
  expect_identical(class(df$arbitrary), "character")
  df$arbitrary <- bless(df$arbitrary, "myclass")
  expect_equal(df, dfi, ignore_attr = TRUE)

})

test_that("dataset_load", {
  local_mocked_bindings(
    dataset_export_to_parquet = function(id, full_path, ...) file.path("CAPTURES", "dataset_load", "userdata1.parquet")
  )

  # Dataset schema
  expect_schema <- arrow::schema(
    registration_dttm = arrow::timestamp("ns"),
    id = arrow::int32(),
    first_name = arrow::string(),
    last_name = arrow::string(),
    email = arrow::string(),
    gender = arrow::string(),
    ip_address = arrow::string(),
    cc = arrow::string(),
    country = arrow::string(),
    birthdate = arrow::string(),
    salary = arrow::float64(),
    title = arrow::string(),
    comments = arrow::string(),
  )
  # expected_schema_class <- c("Schema", "ArrowObject", "R6")
  # Positive testcases
  actual_schema <- Dataset_schema(full_path = "/path/to/dataset")

  expect_equal(names(actual_schema), names(expect_schema))
  expect_equal(class(actual_schema), class(expect_schema))
  expect_equal(actual_schema$types, expect_schema$types)

  # Negative testscases
  expect_error(Dataset_schema(), "A dataset ID or full path is required")

  expect_equal(names(Dataset_schema(id = "1234567")), names(expect_schema))

  expect_equal(
    names(Dataset_schema(parquet_path = file.path("CAPTURES", "dataset_load", "userdata1.parquet"))),
    names(expect_schema)
  )

  expect_equal(
    class(Dataset_schema(parquet_path = file.path("CAPTURES", "dataset_load", "userdata1.parquet"))),
    class(expect_schema)
  )


  # Dataset load
  # Check the tibble returned

  user_data <- Dataset_load(id = "1234567")
  expect_equal(nrow(user_data), 1000)
  expect_equal(ncol(user_data), 13)

  # select fields
  selected_user_data <- Dataset_load(id = "1234567", col_select = c("first_name", "last_name", "country", "title"))
  # expect_equal(nrow(selected_user_data), 1000)
  expect_equal(ncol(selected_user_data), 4)

  # As arrow table

  arrow_table_data <- Dataset_load(
    full_path = "vault_path/to/dataset", col_select = c("first_name", "last_name", "country", "title", "gender", "comments"),
    as_data_frame = FALSE
  )

  expect_equal(ncol(arrow_table_data), 6)
  expect_true("ArrowObject" %in% class(arrow_table_data))

  # Read data into dataframe with schema
  user_data_result <- Dataset_load(full_path = "vault_path/to/dataset", get_schema = TRUE)
  expect_equal(nrow(user_data_result$df), 1000)
  expect_equal(ncol(user_data_result$df), 13)

  expect_equal(names(user_data_result$schema), names(expect_schema))
  expect_equal(user_data_result$schema$types, expect_schema$types)

  # filter data via Arrow expressions
  user_data_filter <- Dataset_load(id = "1234567", filter_expr = arrow::Expression$field_ref("first_name") == "Emily")
  expect_equal(nrow(user_data_filter), 4)
  expect_equal(ncol(user_data_filter), 13)
})
