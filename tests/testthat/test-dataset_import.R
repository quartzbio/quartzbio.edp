test_that_with_edp_api("ds_import_ff", {
  v <- get_test_vault()
  ### capturing needs that we stay there (i.e we do not change the current dir)
  TMPDIR <- setup_temp_dir(chdir = FALSE)

  # prepare the file to upload
  MTCARS <- mtcars[1:3, ]
  MTCARS$car <- rownames(MTCARS)
  rownames(MTCARS) <- NULL

  # write it in a local file
  local_path <- file.path(TMPDIR, "mtcars.csv")
  write.csv(MTCARS, local_path, row.names = FALSE)

  # upload it
  fi <- File_upload(v, local_path, "/a/b/c/mtcars.csv")
  # create the dataset (empty)
  ds <- Dataset_create(v, "mtcars.ds")
  # import the EDP File to the Dataset
  imp <- Dataset_import(ds, file_id = fi, sync = httptest_is_capture_enabled())

  # test the result
  df <- Dataset_query(ds, meta = FALSE)
  # karl: I do not know why, but the import process sems to change the ordering of columns
  expect_equivalent(df[names(MTCARS)], MTCARS)

  # edge cases
  expect_error(Dataset_import(ds, file_id = fi, records = list(toto = 1)), "both be set")
  expect_error(Dataset_import(ds, file_id = fi, df = iris[1:3, ]), "both be set")
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
