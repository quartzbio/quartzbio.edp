# copied from qbutils
setup_temp_dir <- function(chdir = TRUE, ...) {
  dir <- tempfile(...)
  dir.create(dir, recursive = TRUE)
  old_dir <- NULL
  if (chdir) {
    old_dir <- setwd(dir)
  }

  # on one line because it not seen by the coverage
  cleanup <- bquote({
    if (.(chdir)) {
      setwd(.(old_dir))
    }
    unlink(.(dir), recursive = TRUE)
  })

  do.call(add_on_exit, list(cleanup, parent.frame()))

  invisible(normalizePath(dir))
}

add_on_exit <- function(expr, where = parent.frame()) {
  do.call("on.exit", list(substitute(expr), add = TRUE), envir = where)
}

fake_httr_response <- function(
  url,
  content,
  status_code = 200L,
  method = "GET"
) {
  res <- list(
    url = url,
    status_code = status_code,
    content = content,
    request = list(
      method = "GET",
      url = url
    )
  )
  class(res) <- "response"

  res
}

httptest_is_capture_enabled <- function() {
  .is_nz_string(Sys.getenv(
    "MOCK_API_CAPTURE",
    getOption("mock.api.capture", "")
  ))
}

httr_response_set_json_content_to_list <- function(
  res,
  lst,
  pretty = TRUE,
  auto_unbox = FALSE
) {
  res_json <- as.character(jsonlite::toJSON(
    lst,
    pretty = pretty,
    auto_unbox = auto_unbox
  ))
  res$content <- charToRaw(res_json)
  res
}

httptest_set_mock_paths <- function(paths) {
  # get existing paths, and reset them
  old <- httptest::.mockPaths(NULL)
  httptest::.mockPaths(paths)

  old
}

httptest_backup_capture_dir <- function(capture_dir) {
  file.path(dirname(capture_dir), paste0(".", basename(capture_dir)))
}

start_mock_api <- function(
  capture = httptest_is_capture_enabled(),
  capture_dir,
  requester,
  redactor
) {
  backup <- list()
  old <- httptest_set_mock_paths(capture_dir)
  backup$mock_paths <- old

  if (length(requester)) {
    httptest::set_requester(requester)
    backup$requester <- NULL
  }

  if (length(redactor)) {
    httptest::set_redactor(redactor)
    backup$redactor <- NULL
  }

  backup$capture <- capture
  if (capture) {
    if (dir.exists(capture_dir)) {
      bak <- httptest_backup_capture_dir(capture_dir)
      if (dir.exists(bak)) {
        # Delete backup
        unlink(bak, recursive = TRUE)
      }
      # Rename
      die_unless(
        file.rename(capture_dir, bak),
        'could not rename "{capture_dir}" --> "{bak}"'
      )
    }

    # create capture dir
    dir.create(capture_dir, recursive = TRUE)
    httptest::start_capturing()
  } else {
    httptest::use_mock_api()
  }
  backup
}

stop_mock_api <- function(backup) {
  httptest_set_mock_paths(backup$mock_paths)

  httptest::set_requester(backup$requester)
  httptest::set_redactor(backup$redactor)

  if (backup$capture) {
    httptest::stop_capturing()
  } else {
    httptest::stop_mocking()
  }
}
