offset_to_page <- quartzbio.edp:::offset_to_page
page_to_offset <- quartzbio.edp:::page_to_offset

test_that("page_to_offset", {
  expect_equal(page_to_offset(1, 10), 0)
  expect_equal(page_to_offset(1, 2), 0)

  expect_equal(page_to_offset(2, 3), 3)
  expect_equal(page_to_offset(3, 3), 6)
  expect_equal(page_to_offset(10, 3), 27)
})


test_that("offset_to_page", {
  expect_equal(offset_to_page(0, 10), 1)
  expect_equal(offset_to_page(0, 2), 1)

  expect_equal(offset_to_page(3, 3), 2)
  expect_equal(offset_to_page(6, 3), 3)
  expect_equal(offset_to_page(9, 3), 4)
})
