# N.B: currently S3 downloads and uploads can not be captured by httptest.
# so we'll use httr::set_callback() to simulate those downloads/uploads
library(mockery)

test_that_with_edp_api("file_download", {
  v <- get_test_vault()

  fi <- quartzbio.edp:::File_create(v, "toto")

  ### simulate download
  URL <- "http://whatever.com/x/y/z?toto=titi"
  RES <- fake_httr_response(URL, "hello world")
  RES$download_url <- URL
  faker <- function(req) {
    RES
  }
  old_callback <- httr::set_callback("request", faker)
  on.exit(httr::set_callback("request", old_callback), add = TRUE)

  local_path <- tempfile()

  res <- File_download(fi, local_path)
  expect_identical(res, RES)

  ### File_read
  writeLines("coucou", local_path)
  expect_identical(File_read(fi, local_path = local_path, overwrite = TRUE), "coucou")

  ###
  # because of the faked httr download, the file is not created
  expect_warning(
    expect_error(File_read(fi), "cannot open"),
    "No such file"
  )
})

test_that_with_edp_api("File_upload works with mock API", {
  v <- get_test_vault()
  TMPDIR <- setup_temp_dir(chdir = FALSE)

  # Create a small numeric-only test file
  MTCARS <- mtcars[1:3, ]
  rownames(MTCARS) <- NULL
  local_path <- file.path(TMPDIR, "mtcars.csv")
  write.csv(MTCARS, local_path, row.names = FALSE)

  # Set a mock vault path and vault id
  vault_path <- "/mock/path/mtcars.csv"
  vault_id <- v

  # Run File_upload (should use mock API responses)
  mockery::stub(File_upload, "request_edp_api", list(upload_url = "https://mock-upload-url"))

  mockery::stub(File_upload, "httr::PUT", list(
    status_code = function(x) 200
  ))

  mockery::stub(File_upload, "File_create", list(
    id = "mock-object-id",
    path = "/mock/path/mtcars.csv",
    is_multipart = FALSE,
    upload_url = "https://mock-url/upload"
  ))
  obj <- File_upload(vault_id, local_path, vault_path)

  # Check that the returned object is a list and has expected fields
  expect_true(is.list(obj))
  expect_true(!is.null(obj$id))
  expect_equal(obj$path, vault_path)
  expect_equal(obj$id, "mock-object-id")
})




test_that_with_edp_api("Multi_part_file_upload works with mock API", {
  v <- get_test_vault()
  TMPDIR <- setup_temp_dir(chdir = FALSE)

  # Create a large test file to trigger multipart upload (e.g., >64MB)
  large_file <- file.path(TMPDIR, "large_test_file.bin")
  # Write 95MB of random data
  writeBin(as.raw(sample(0:255, 95 * 1024 * 1024, replace = TRUE)), large_file)

  # Mock vault path and vault id
  vault_path <- "/mock/path/large_test_file.bin"
  vault_id <- v

  # Create a mock file object with multipart enabled and presigned_urls
  obj <- list(
    is_multipart = TRUE,
    presigned_urls = list(
      list(part_number = 1, start_byte = 0, end_byte = 32 * 1024 * 1024 - 1, size = 32 * 1024 * 1024, upload_url = "https://mock-url/part1"),
      list(part_number = 2, start_byte = 32 * 1024 * 1024, end_byte = 65 * 1024 * 1024 - 1, size = 33 * 1024 * 1024, upload_url = "https://mock-url/part2")
    ),
    upload_id = "mock-upload-id",
    upload_key = "mock-upload-key",
    client = NULL,
    path = vault_path
  )

  mockery::stub(Multi_part_file_upload, "httr::PUT", list(
    status_code = function(x) 200,
    headers = function(x) list(etag = "\"mock-etag\"")
  ))

  # Mock request_edp_api to return a successful completion message
  mockery::stub(Multi_part_file_upload, "request_edp_api", list(message = "Multipart upload complete"))

  # Run Multi_part_file_upload (should use mock API responses)
  result <- Multi_part_file_upload(
    obj = obj,
    local_path = large_file,
    local_md5 = tools::md5sum(large_file)[[1]],
    num_processes = 1,
    max_retries = 3
  )

  # Check that the returned object is a list and has expected fields
  expect_true(is.list(result))
  expect_equal(result$path, vault_path)

  unlink(large_file)
})
