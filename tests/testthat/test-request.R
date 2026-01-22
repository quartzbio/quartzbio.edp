# N.B: only testing the fake_response part. The standard behaviour is already tested in request_edp_api
test_that("send_request", {
  send_request <- quartzbio.edp:::send_request

  res <- build_httr_response(
    "dummy",
    code = 429L,
    headers = list(
      `content-type` = "application/json",
      `retry-after` = 0.2
    )
  )

  ### 429
  expect_error(
    send_request("GET", fake_response = res),
    "retries are exhausted"
  )

  ### normal
  res$status_code <- 200
  res2 <- send_request("GET", fake_response = res)
  expect_identical(res2, res)
})


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
  expect_identical(
    process(.by(id = 0, name = "toto"), unique = FALSE),
    list(id = 0, name = "toto")
  )

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
  expect_identical(
    process(.by(id = 0, a = 1, b = 2), unique = FALSE),
    list(id = 0, a = 1, b = 2)
  )
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


test_that_with_edp_api(
  "request_edp_api_429",
  {
    request_edp_api <- quartzbio.edp:::request_edp_api
    expect_error(Vaults(), "retries are exhausted")
  },
  can_capture = FALSE
)


test_that_with_edp_api("request_edp_api", {
  request_edp_api <- quartzbio.edp:::request_edp_api
  conn <- get_connection(auto = FALSE)

  ### using v1/user
  res <- request_edp_api("GET", "v1/user", conn = conn)

  expect_true(is.list(res))
  expect_true(all(
    c("class_name", "full_name", "id", "username") %in% names(res)
  ))
  expect_identical(class(res), c("User", "list"))

  # raw = TRUE
  res3 <- request_edp_api("GET", "v1/user", raw = TRUE, conn = conn)
  expect_s3_class(res3, "response")
  expect_identical(httr::content(res3)$username, res$username)

  ### leading /slash
  res2 <- request_edp_api("GET", "/v1/user", conn = conn)
  expect_equal(res2, res)

  ### using slow/legacy content parser
  res2 <- request_edp_api("GET", "/v1/user", conn = conn, parse_fast = FALSE)
  expect_identical(res2$username, res$username)

  ### using query
  # TODO: these tests need to be fixed. They assume that there >= 5 datasets
  # # bigger limit
  # datasets1 <- request_edp_api('GET', 'v2/datasets',  query = list(limit = 5), conn = conn)
  # datasets <- request_edp_api('GET', 'v2/datasets',  query = list(limit = 2), conn = conn)
  # expect_length(datasets$data, min(2, length(datasets1$data)))

  # ### using param=, and limit=, page=
  # # limit= and page=
  # ds2.1 <- request_edp_api('GET', 'v2/datasets',  limit = 2, page = 1, conn = conn)
  # ds2.2 <- request_edp_api('GET', '/v2/datasets',  limit = 2, page = 2, conn = conn)
  # ds4 <- request_edp_api('GET', 'v2/datasets',  limit = 4, conn = conn)

  # expect_identical(ds4$data, c(ds2.1$data, ds2.2$data))

  # # using params=
  # ds2.2_bis <- request_edp_api('GET', 'v2/datasets',  params = list(limit = 2, page = 2), conn = conn)

  # expect_equal(ds2.2_bis, ds2.2)
  # # using query=
  # ds2.2_ter <- request_edp_api('GET', 'v2/datasets',  query = list(limit = 2, page = 2), conn = conn)
  # expect_equal(ds2.2_ter, ds2.2)

  # ids <- sapply(ds4, getElement, 'id')
  # ### using body=
  # api_path <- file.path("v2/datasets", ids[1], "data")
  # res <- request_edp_api('POST', api_path,
  #   body = list(limit = 2, fields = list('name', 'date_modified')), conn = conn)

  # expect_length(res, 2)
  # expect_identical(names(res[[1]]), c('name', 'date_modified'))

  # # with params=
  # res2 <- request_edp_api('POST', api_path,
  #   params = list(limit = 2, fields = list('name', 'date_modified')), conn = conn)
  # expect_equal(res2, res)
})


test_that("format_auth_header", {
  format_auth_header <- quartzbio.edp:::format_auth_header
  # key
  secret <- strrep("X", 40)
  expect_identical(
    format_auth_header(secret),
    c(Authorization = paste("Token", secret))
  )

  # TOKEN
  secret <- strrep("X", 30)
  expect_identical(
    format_auth_header(secret),
    c(Authorization = paste("Bearer", secret))
  )
})
