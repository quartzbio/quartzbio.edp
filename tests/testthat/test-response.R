### test shared function
dummy_httr_request <- function(status, headers = list(`Content-Type` = "application/json"), content = NULL) {
  x <- list(status = status, headers = headers)
  if (length(content)) {
    x <- httr_response_set_json_content_to_list(x, content, auto_unbox = TRUE)
  }
  class(x) <- "response"
  x
}




test_that("classify_entity", {
  classify_entity <- quartzbio.edp:::classify_entity

  ### if no class_name, does nothing
  expect_identical(classify_entity(NULL), NULL)
  expect_identical(classify_entity(1), 1)

  ### with class_name
  x <- list(a = 1, object_type = "titi", class_name = "toto")

  y <- classify_entity(x)

  class(x) <- c("toto", "list")
  expect_identical(y, x)

  ### with Object --> use object_type
  x <- list(a = 1, object_type = "titi", class_name = "Object")

  y <- classify_entity(x)

  class(x) <- c("Titi", "Object", "list")
  expect_identical(y, x)
})



test_that("postprocess_single_entity", {
  postprocess_single_entity <- quartzbio.edp:::postprocess_single_entity

  x <- list(a = 1, object_type = "titi", class_name = "Object", toto_id = 1, vault_id = "a")

  conn <- list()
  y <- postprocess_single_entity(x, conn)

  # class
  expect_identical(class(y), c("Titi", "Object", "list"))
  # its IDs
  expect_identical(class(y$toto_id), "numeric")
  expect_identical(class(y$vault_id), "character")

  class(y) <- class(y)[-(1:2)]
  class(y$toto_id) <- class(y$toto_id)[-1]
  class(y$vault_id) <- class(y$vault_id)[-1]

  expect_equal(y, x, ignore_attr = TRUE)
})


# TODO: implement test
.postprocess_response <- function() {
  test_that("postprocess_response", {
    postprocess_response <- quartzbio.edp:::postprocess_response
    conn <- list()

    ### download_url case: no class_name
    res <- list(url = "toto", object_id = NULL)
    expect_equal(postprocess_response(res, is_df = FALSE, conn), res)

    ### edge cases
    res <- list(data = 1, class_name = "list")

    x <- postprocess_response(res, is_df = FALSE, conn)
    expect_equal(x, list(1))
  })
}



test_that("process_by_params", {
  process <- quartzbio.edp:::process_by_params

  ### edge cases --> must be non empty named list
  expect_error(process(list(1)), "must be a named list")
  expect_error(process(list()), "can not be empty")

  ### standard case
  .by <- function(id = NULL, full_path = NULL, name = NULL) {
    list(id = id, full_path = full_path, name = name)
  }
  # exactly one must be set

  expect_error(process(.by()), "exactly one")
  expect_error(process(.by(id = 0, name = "toto")), "exactly one")

  expect_identical(process(.by(id = 0)), list(id = 0))
  expect_identical(process(.by(full_path = "/dir/")), list(full_path = "/dir/"))
  expect_identical(process(.by(name = "toto")), list(name = "toto"))

  ### unique = FALSE
  expect_error(process(.by(), unique = FALSE), "at least one")
  expect_identical(process(.by(id = 0, name = "toto"), unique = FALSE), list(id = 0, name = "toto"))

  ### unique = FALSE, empty = TRUE
  expect_identical(process(.by(), empty = TRUE), list())

  ### sublists
  .by <- function(id = NULL, a = NULL, b = NULL) {
    list(id = id, lst = list(a = a, b = b))
  }
  expect_error(process(.by()), "exactly one")
  expect_error(process(.by(a = 1)), "all items")

  expect_identical(process(.by(a = 1, b = 2)), list(a = 1, b = 2))

  expect_error(process(.by(id = 0, a = 1, b = 2)), "exactly one")
  expect_identical(process(.by(id = 0, a = 1, b = 2), unique = FALSE), list(id = 0, a = 1, b = 2))
  expect_identical(process(.by(), empty = TRUE), list())


  ### 2 sublists
  .by <- function(id = NULL, a = NULL, b = NULL) {
    list(ids = list(id1 = id, id2 = id), lst = list(a = a, b = b))
  }

  expect_error(process(.by()), "exactly one")
  expect_error(process(.by(a = 1)), "all items")

  expect_identical(process(.by(a = 1, b = 2)), list(a = 1, b = 2))
  expect_identical(process(.by(id = 0)), list(id1 = 0, id2 = 0))

  expect_error(process(.by(id = 0, a = 1, b = 2)), "exactly one")
  expect_identical(
    process(.by(id = 0, a = 1, b = 2), unique = FALSE),
    list(id1 = 0, id2 = 0, a = 1, b = 2)
  )
})



test_that("detect_ids", {
  detect_ids <- quartzbio.edp:::detect_ids

  lst <- list(id = 0, vault_id = 1, toto_id = 2, foo = "a", sublist = list(a_id = 1))

  classes <- detect_ids(lst)

  expect_identical(
    classes,
    list(c("VaultId", "numeric"), c("TotoId", "numeric"))
  )
})



test_that("apply_class_to_ids", {
  apply_class_to_ids <- quartzbio.edp:::apply_class_to_ids
  detect_ids <- quartzbio.edp:::detect_ids

  lst <- list(id = 0, vault_id = 1, toto_id = 2, foo = "a", sublist = list(a_id = 1))
  classes <- detect_ids(lst)

  lst2 <- apply_class_to_ids(lst, classes)

  .class <- function(x) class(x)[1]
  expect_equal(sapply(lst2, .class), c("numeric", "numeric", "numeric", "character", "list"), ignore_attr = TRUE)
})



test_that("check_httr_response", {
  check <- quartzbio.edp:::check_httr_response
  .resp <- dummy_httr_request

  ### non-errors
  expect_error(expect_true(check(.resp(200))), NA)
  expect_error(expect_true(check(.resp(300))), NA)
  expect_error(expect_true(check(.resp(399))), NA)

  # 204, 301, 302 --> moved or n content
  for (status in c(204, 301, 302)) {
    res <- .resp(status)
    expect_identical(check(res), res)
  }

  # 404: not found
  expect_null(check(.resp(404)))

  ### 401: Unauthorized
  # with details
  expect_error(check(.resp(401, content = list(details = "coucou"))), "Unauthorized: coucou")

  # with msg but no details
  expect_error(check(.resp(401, content = list(x = "guess what"))), "Unauthorized: guess what")

  # weird content
  expect_error(check(.resp(401, content = 1)), "Unauthorized: 1")
  expect_error(check(.resp(401)), "Unauthorized:\\s*\\(error 401\\)")

  ### other errors
  expect_error(check(.resp(400, content = list(details = "coucou"))), "API error: coucou")
  expect_error(check(.resp(400)), "API error: ")

  expect_error(check(.resp(9999)), "Uknown API error 9999")
  expect_error(check(.resp(9999, content = list(details = "coucou"))), "Uknown API error 9999: coucou")

  ### html content type
  # create a fake httr reponse (cf fake_httr_response
  url <- "https://sandbox.edp.aws.quartz.bio/v1/user"

  res <- dummy_httr_request(200,
    headers = list(`Content-Type` = "text/html; charset=utf-8"),
    content = "<html></html>"
  )
  expect_identical(check(res), res)
})




test_that("get_api_response_error_message", {
  get_msg <- quartzbio.edp:::get_api_response_error_message
  .resp <- dummy_httr_request

  ### no content
  expect_identical(get_msg(.resp(200), "default"), "default")
  expect_identical(get_msg(.resp(200)), "")

  ### standard API error message (details)
  expect_identical(get_msg(.resp(401, content = list(details = "coucou"))), "coucou")

  expect_identical(get_msg(.resp(401, content = list("hello")), "toto"), "hello")
  expect_identical(get_msg(.resp(401, content = LETTERS[1:5]), "toto"), "A, B, C, D, E")
  expect_identical(get_msg(.resp(401, content = 1), "toto"), "1")

  ### edge cases
  expect_identical(get_msg(2), "Error parsing API response")
})
