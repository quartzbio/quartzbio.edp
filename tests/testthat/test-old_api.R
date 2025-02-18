.login <- function(conn) {
  ### test env vars: KEY
  ALL_ENVS <- c(
    SOLVEBIO_API_KEY = "", SOLVEBIO_API_TOKEN = "",
    SOLVEBIO_API_HOST = ""
  )
  we <- function(envs, ...) {
    missing_envs <- setdiff(names(ALL_ENVS), names(envs))
    envs <- c(envs, ALL_ENVS[missing_envs])
    withr::with_envvar(envs, ...)
  }

  ### explicit
  expect_error(login(conn$secret, api_host = conn$host), NA)

  expect_identical(get_connection(auto = FALSE), conn)
  x <- User.retrieve()

  expect_true(x$is_active)
  expect_s3_class(x, "User")

  ### via env vars
  we(c(SOLVEBIO_API_KEY = conn$secret, SOLVEBIO_API_HOST = conn$host), {
    expect_error(login(), NA)
  })

  we(c(SOLVEBIO_ACCESS_TOKEN = conn$secret, SOLVEBIO_API_HOST = conn$host), {
    expect_error(login(), NA)
  })
}
test_that_with_edp_api("login", .login)
