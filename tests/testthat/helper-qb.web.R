############################################ test helper function for EDP api

EDP_TEST_PROFILE <- Sys.getenv("EDP_TEST_PROFILE", "vsim-dev_rw")
EDP_DUMMY_CONN <- list(
  secret = strrep("X", 30),
  host = "https://vsim-dev.api.edp.aws.quartz.bio"
)

# setup a vault dedicated to running these package tests

.test_env_setup <- function(name) {
  v <- Vault_create(
    name = name,
    description = "quartzbio.edp R package temp test vault",
    storage_class = "Temporary",
    tags = "TESTING"
  )
}
.test_env_teardown <- function(vault) {
  try(delete(vault))
}

# N.B: the connection must be mocked !!
.edp_fetch_connection <- function(capturing) {
  if (capturing) {
    read_connection_profile(EDP_TEST_PROFILE)
  } else {
    EDP_DUMMY_CONN
  }
}

.requester <- function(req) {
  # shorten the URLs
  api_url <- EDP_DUMMY_CONN$host
  req$url <- sub(api_url, "", req$url)

  # s3 uploads
  req$url <- sub("https://.+.s3.amazonaws.com", "s3", req$url)

  # remove all /v2/
  if (startsWith(req$url, "/v2/")) {
    req$url <- sub("/v2", "", req$url)
  }

  # some urls are too long, e.g. "/v2/datasets/1904014068027535892/data"
  if (startsWith(req$url, "/datasets/")) {
    req$url <- sub("/datasets/", "/DS/", req$url)
  }

  req
}

# this redactor has two purposes:
# 1- to reduce the capture files size for speed and space optimization
.redactor <- function(res) {
  # remove the account part from the v1/account
  if (endsWith(res$url, "v1/user")) {
    x <- httr::content(res)
    x$account <- NULL
    res <- httr_response_set_json_content_to_list(res, x, auto_unbox = TRUE)
  }

  res
}

.vault_name <- function(desc) paste0("quartzbio.edp.test.", desc)

test_that_with_edp_api <- function(
  desc,
  expr,
  verbose = FALSE,
  connector = .edp_fetch_connection,
  can_capture = TRUE,
  capture_dir = file.path("CAPTURES", desc)
) {
  capture <- httptest_is_capture_enabled() && can_capture

  backup <- start_mock_api(
    capture = capture,
    capture_dir = capture_dir,
    requester = .requester,
    redactor = .redactor
  )
  on.exit(stop_mock_api(backup), add = TRUE)

  CONNECTION <- connector(backup$capture)
  old_conn <- get_connection(auto = FALSE)
  set_connection(CONNECTION, check = FALSE)

  if (capture) {
    vault_name <- .vault_name(desc)
    v <- .test_env_setup(vault_name)
    on.exit(.test_env_teardown(v), add = TRUE)
  }
  on.exit(set_connection(old_conn, check = FALSE), add = TRUE)

  # make the get_test_vault() function available from tests
  get_test_vault <- function() {
    Vault(name = .vault_name(desc))
  }
  assign("get_test_vault", get_test_vault, envir = parent.frame())

  test_that(desc, expr)
}
