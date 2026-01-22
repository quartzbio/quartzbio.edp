test_that("is_defined_scalar_integer", {
  is_defined_scalar_integer <- quartzbio.edp:::is_defined_scalar_integer

  # length 0
  expect_false(is_defined_scalar_integer(NULL))
  expect_false(is_defined_scalar_integer(list()))
  expect_false(is_defined_scalar_integer(c()))
  expect_false(is_defined_scalar_integer(numeric()))
  expect_false(is_defined_scalar_integer(integer()))

  # length > 1
  expect_false(is_defined_scalar_integer(iris))
  expect_false(is_defined_scalar_integer(numeric(2)))
  expect_false(is_defined_scalar_integer(integer(3)))

  # scalar but not integer
  expect_false(is_defined_scalar_integer(NA_real_))
  expect_false(is_defined_scalar_integer(NA))
  expect_false(is_defined_scalar_integer("3"))
  expect_false(is_defined_scalar_integer(pi))
  expect_false(is_defined_scalar_integer(list))
  expect_false(is_defined_scalar_integer(new.env()))

  # integers
  expect_true(is_defined_scalar_integer(0L))
  expect_true(is_defined_scalar_integer(0))
  expect_true(is_defined_scalar_integer(10))
  expect_true(is_defined_scalar_integer(-1))
})


test_that("IF_EMPTY_THEN", {
  expect_identical(1 %IF_EMPTY_THEN% 2, 1)
  expect_identical(iris %IF_EMPTY_THEN% 2, iris)
  expect_identical(sum %IF_EMPTY_THEN% 2, sum)

  expect_identical(NA %IF_EMPTY_THEN% 2, NA)
  expect_identical(NULL %IF_EMPTY_THEN% 2, 2)
  expect_identical(list() %IF_EMPTY_THEN% 2, 2)
  expect_identical(character() %IF_EMPTY_THEN% 2, 2)
  expect_identical(c() %IF_EMPTY_THEN% 2, 2)
})


test_that("scalarize_list", {
  scalarize_list <- quartzbio.edp:::scalarize_list

  ### edge cases
  expect_identical(scalarize_list(NULL), NULL)
  expect_identical(scalarize_list(list()), list())
  expect_identical(scalarize_list(list(1)), list(1))
  expect_identical(scalarize_list(list(1, "toto")), list(1, "toto"))

  ### standard use
  expect_identical(
    scalarize_list(list(a = 1, b = 1:3, c = LETTERS[1:2])),
    list(a = 1, b = 1L, b = 2L, b = 3L, c = "A", c = "B")
  )

  ### no names ?
  expect_identical(scalarize_list(list(1:3)), list(1L, 2L, 3L))
})


test_that("hex2raw", {
  hex2raw <- quartzbio.edp:::hex2raw

  ### edge cases
  expect_error(hex2raw(NULL), "not a valid")
  expect_error(hex2raw(1), "not a valid")
  expect_error(hex2raw("F"), "not a valid")
  expect_error(hex2raw("G"), "not a valid")
  expect_error(hex2raw(""), "not a valid")
  expect_error(hex2raw("FFF"), "not a valid")

  ###
  expect_equal(hex2raw("FF"), as.raw(255))
  expect_equal(hex2raw("2A"), as.raw(strtoi("2A", base = 16)))
  expect_equal(hex2raw("0102030405060708090a0b0c0d0e0f"), as.raw(1:15))

  expect_equal(hex2raw(c("FE", "FF")), as.raw(254:255))
})


test_that("path_make_absolute", {
  path_make_absolute <- quartzbio.edp:::path_make_absolute

  expect_identical(path_make_absolute(""), "/")

  expect_identical(path_make_absolute("toto"), "/toto")
  expect_identical(path_make_absolute("/toto"), "/toto")
  expect_identical(path_make_absolute("A"), "/A")
})


test_that("bless", {
  bless <- quartzbio.edp:::bless

  x <- bless(1, "toto")
  expect_identical(class(x), c("toto", class(1)))
  expect_identical(unclass(x), 1)

  ###
  x <- bless(2L, "toto", "titi")
  expect_identical(class(x), c("toto", "titi", class(2L)))
  expect_identical(unclass(x), 2L)

  ### edge case
  x <- bless(NULL, "toto")
  expect_equal(x, data.frame(), ignore_attr = TRUE)
  expect_identical(class(x), c("toto", "data.frame"))
})


test_that("capitalize", {
  capitalize <- quartzbio.edp:::capitalize

  expect_identical(capitalize("folder"), "Folder")
  expect_identical(capitalize("Folder"), "Folder")
  expect_identical(capitalize("a"), "A")
})


test_that("convert_edp_list_to_df", {
  todf <- quartzbio.edp:::convert_edp_list_to_df

  ### edge cases
  expect_null(todf(NULL))
  expect_null(todf(list()))

  ### one row
  lst <- list(
    list(
      account_id = structure(7L, class = "AccountId"),
      description = NULL,
      has_children = TRUE,
      id = 28L,
      metadata = list(),
      name = "Comparison Projects",
      permissions = list(read = TRUE, write = FALSE, admin = FALSE)
    )
  )

  df <- todf(lst)

  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 1)
  expect_identical(names(df), names(lst[[1]]))
  expect_equal(
    sapply(df, class),
    c("integer", "list", "logical", "integer", "list", "character", "list"),
    ignore_attr = TRUE
  )

  ### two rows
  row2 <- lst[[1]]
  row2$id <- 0L
  row2$metadata <- list(author = "Jules")
  row2$permissions$read <- FALSE

  lst2 <- c(lst, list(row2))

  df <- todf(lst2)

  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 2)
  expect_identical(names(df), names(lst2[[1]]))
  expect_equal(
    sapply(df, class),
    c("integer", "list", "logical", "integer", "list", "character", "list"),
    ignore_attr = TRUE
  )
  expect_false(df$permissions[[2]]$read)
  expect_equal(df$id, c(28, 0))
})


test_that("summary_string", {
  summary_string <- quartzbio.edp:::summary_string

  # empty
  expect_identical(summary_string(NULL), "")
  expect_identical(summary_string(list()), "")

  # standard
  expect_identical(
    summary_string(list(axx = TRUE, byy = FALSE, Cxx = TRUE)),
    "AbC"
  )
  expect_identical(
    summary_string(list(xY = TRUE, axx = 1, byy = FALSE, Cxx = TRUE)),
    "XabC"
  )
})


test_that("id", {
  id <- quartzbio.edp:::id

  # not lists
  expect_identical(id("toto"), "toto")
  expect_identical(id(1L), 1L)
  expect_identical(id(1), 1)
  expect_identical(id(NA), NA)
  expect_identical(id(NULL), NULL)

  # lists
  expect_identical(id(list()), list())
  expect_identical(id(iris), iris)
  expect_identical(id(list(a = 1, id = "toto")), "toto")
  expect_identical(id(list(a = 1, id = 2)), 2)
})
