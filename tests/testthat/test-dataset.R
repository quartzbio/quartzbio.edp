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

  ### methods
  ds1bis <- fetch(ds$dataset_id)

  expect_s3_class(ds1bis, "Dataset")
  expect_identical(ds1bis$id, ds$id)
})
