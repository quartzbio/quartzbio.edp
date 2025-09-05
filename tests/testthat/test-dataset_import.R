test_that_with_edp_api("ds_import_ff", {
  v <- get_test_vault()
  TMPDIR <- setup_temp_dir(chdir = FALSE)

  # Use only numeric columns for MTCARS
  MTCARS <- mtcars[1:3, ]
  rownames(MTCARS) <- NULL

  # Write to local file
  local_path <- file.path(TMPDIR, "mtcars.csv")
  write.csv(MTCARS, local_path, row.names = FALSE)

  # Use a mock file_id for import
  #fi <- File_upload(v, local_path, "/a/b/c/mtcars.csv")

  # Create the dataset (empty)
  ds <- Dataset_create(v, "mtcars.ds")
  # Import the EDP File to the Dataset
  imp <- Dataset_import(ds, file_id = "12234", sync = httptest_is_capture_enabled())

  # Test the result
  df <- Dataset_query(ds, meta = FALSE)
  expect_equivalent(df[names(MTCARS)], MTCARS)

  # Edge cases: should error if both file_id and records/df are set
  expect_error(Dataset_import(ds, file_id = "12234", records = list(toto = 1)), "both be set")
  expect_error(Dataset_import(ds, file_id = "12234", df = iris[1:3, ]), "both be set")
})



# .dataset_import <- function()
test_that_with_edp_api("dataset_import", {
  v <- get_test_vault()
  MTCARS <- mtcars
  MTCARS$car <- rownames(MTCARS)
  rownames(MTCARS) <- NULL

  ds <- Dataset_create(v, "mtcars.ds")

  # test the timeout with sync=TRUE
  expect_warning(
    res <- Dataset_import(ds, df = MTCARS, sync = TRUE, retries = 0),
    "timeout"
  )

  ### check the result
  df <- Dataset_query(ds)
  expect_equal(df, MTCARS, ignore_attr = TRUE)
})
