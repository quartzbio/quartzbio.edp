# N.B: currently S3 downloads and uploads can not be captured by httptest.
# so we'll use httr::set_callback() to simulate those downloads/uploads

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
