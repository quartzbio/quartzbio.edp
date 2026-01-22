test_that("print.edplist", {
  lst <- as.list(head(mtcars))
  class(lst) <- c("edplist", class(lst))

  lines <- strsplit(capture_output(print(lst)), "\n")[[1]]
  expect_match(lines[1], "EDP List")
  expect_gt(length(lines), 12)

  ### empty list
  lst <- list()
  class(lst) <- c("edplist", class(lst))

  lines <- strsplit(capture_output(print(lst)), "\n")[[1]]

  expect_match(lines[1], "EDP List")
  expect_length(lines, 1)
})


test_that("method_defaults", {
  expect_error(delete(1), "Not yet implemented")
  expect_error(fetch(1), "Not yet implemented")
  expect_error(fetch_vaults(1), "Not yet implemented")
})
