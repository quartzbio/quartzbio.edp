test_that("Configure logger without logger", {
  mockery::stub(configure_logger, "requireNamespace", function(...) FALSE)
  expect_warning(configure_logger("log_file_test.log"), regexp = "The 'logger' package is not installed. Logging will be disabled.")
})

test_that("Configure logger test", {
  mockery::stub(configure_logger, "requireNamespace", function(...) TRUE)
  expect_equal(configure_logger("log_file_test.log"), "log_file_test.log")
  expect_warning(configure_logger(NULL), regexp = "Invalid file path for log file. Defaulting to console logging")
  expect_equal(configure_logger(NULL), "console")
})

test_that("log message", {
  mockery::stub(log_message, "requireNamespace", function(...) TRUE)
  log <- log_message("INFO", "This is a info log")
  expect_equal(log$default$message, "This is a info log")
  expect_equal(attributes(log$default$level)$level, "INFO")

  log <- log_message("WARN", "This is a warn log")
  expect_equal(log$default$message, "This is a warn log")
  expect_equal(attributes(log$default$level)$level, "WARN")

  log <- log_message("ERROR", "This is a error log")
  expect_equal(log$default$message, "This is a error log")
  expect_equal(attributes(log$default$level)$level, "ERROR")

  log <- log_message("FATAL", "This is a fatal log")
  expect_equal(log$default$message, "This is a fatal log")
  expect_equal(attributes(log$default$level)$level, "FATAL")

  logger::log_threshold("TRACE")
  log <- log_message("DEBUG", "This is a debug log")
  expect_equal(log$default$message, "This is a debug log")
  expect_equal(attributes(log$default$level)$level, "DEBUG")
})

test_that("log message without logger", {
  mockery::stub(log_message, "requireNamespace", function(...) FALSE)

  expect_message(log_message("INFO", "This is a info log"), "INFO: This is a info log")
  expect_message(log_message("DEBUG", "This is a debug message"), "DEBUG: This is a debug message")
  expect_warning(log_message("WARN", "This is a warning"), "WARNING: This is a warning")
})

test_that("edp_health_check", {
  envs <- c(EDP_API_SECRET = strrep("X", 30), EDP_API_HOST = "host")
  # withr::with_envvar(envs, ))
  withr::with_envvar(envs, {
    expect_error(edp_health_check(), regexp = "autoconnect\\(\\) failed")
  })

  # invalid secret
  envs_2 <- c(EDP_API_SECRET = strrep("X", 31), EDP_API_HOST = "host")
  withr::with_envvar(envs_2, {
    expect_error(edp_health_check(), regexp = "autoconnect\\(\\) failed")
  })
})
