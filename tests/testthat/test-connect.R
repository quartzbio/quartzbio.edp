### tests
test_that_with_edp_api("real_connections", {
  conn <- get_connection(auto = FALSE)

  ### connect
  conn2 <- connect(conn$secret, conn$host)
  expect_identical(conn2, conn)

  ### get_connection auto
  set_connection(NULL)
  expect_null(get_connection(auto = FALSE))

  conn3 <- withr::with_envvar(
    c(EDP_API_SECRET = conn$secret, EDP_API_HOST = conn$host),
    get_connection()
  )
  expect_identical(conn3, conn)
})


test_that_with_edp_api("test_connection", {
  conn <- get_connection(auto = FALSE)
  ### test a bad connection
  bad_conn <- conn
  bad_conn$secret <- strrep("X", 30)

  expect_warning(
    expect_error(test_connection(bad_conn), "Unauthorized"),
    "Unauthorized"
  )
})


test_that("test_conn_error", {
  conn <- EDP_DUMMY_CONN

  ### with a URL that works but that is not EDP
  expect_warning(
    expect_error(httptest::without_internet(test_connection(conn)), "GET"),
    "GET"
  )
})


test_that("autoconnect", {
  setup_temp_dir()

  withr::with_envvar(c(HOME = getwd(), USERPROFILE = getwd()), {
    ALL_ENVS <- c(
      EDP_API_SECRET = "",
      SOLVEBIO_ACCESS_TOKEN = "",
      EDP_API_HOST = "",
      SOLVEBIO_API_HOST = "",
      EDP_PROFILE = "",
      EDP_CONFIG = ""
    )
    we <- function(envs, ...) {
      missing_envs <- setdiff(names(ALL_ENVS), names(envs))
      envs <- c(envs, ALL_ENVS[missing_envs])
      withr::with_envvar(envs, ...)
    }

    ### nothing set --> should fail
    we(
      NULL,
      expect_error(
        autoconnect(check = FALSE),
        "autoconnect() failed",
        fixed = TRUE
      )
    )

    TOKEN <- strrep("Y", 30)
    ### use new vars
    we(
      c(EDP_API_SECRET = TOKEN, EDP_API_HOST = "host"),
      expect_identical(
        autoconnect(check = FALSE),
        list(secret = TOKEN, host = "host")
      )
    )

    ### use old vars
    we(
      c(SOLVEBIO_ACCESS_TOKEN = TOKEN, SOLVEBIO_API_HOST = "host"),
      expect_identical(
        autoconnect(check = FALSE),
        list(secret = TOKEN, host = "host")
      )
    )

    ### use profile
    conn <- list(secret = TOKEN, host = "host")

    # default profile
    we(NULL, {
      save_connection_profile(conn)
      expect_identical(autoconnect(check = FALSE), conn)
    })

    save_connection_profile(conn, profile = "toto")

    we(c(EDP_PROFILE = "toto"), {
      expect_identical(autoconnect(check = FALSE), conn)
    })

    # EDP_CONFIG
    config <- file.path(getwd(), ".qb/toto.json")
    file.rename(file.path(getwd(), ".qb/edp.json"), config)
    we(c(EDP_PROFILE = "toto", EDP_CONFIG = config), {
      expect_identical(autoconnect(check = FALSE), conn)
    })
  })
})


test_that("get_set_connection", {
  old <- get_connection(auto = FALSE)
  on.exit(set_connection(old, check = FALSE), add = TRUE)

  ### set_connection, no check
  conn <- list(secret = strrep("X", 30), host = "host")
  set_connection(conn, check = FALSE)
  expect_identical(get_connection(auto = FALSE), conn)

  #
  set_connection(NULL, check = FALSE)
  expect_null(get_connection(auto = FALSE))

  ### set_connection, with check
  expect_error(set_connection(1, check = TRUE), 'no "secret" in connection')
})


test_that("check_connection", {
  check_connection <- quartzbio.edp:::check_connection

  ### positives
  expect_error(
    check_connection(list(secret = strrep("X", 30), host = "host")),
    NA
  )
  # also works with an environment
  expect_error(
    check_connection(as.environment(list(
      secret = strrep("X", 30),
      host = "host"
    ))),
    NA
  )

  ### negatives
  expect_error(
    check_connection(list(secret = strrep("X", 20), host = "host")),
    "not look like"
  )
  expect_error(check_connection(list(host = "host")), "secret")
  expect_error(check_connection(list(secret = strrep("X", 20))), "host")
  expect_error(check_connection(1), "secret")
  expect_error(check_connection(list()), "bad connection")
})


test_that("looks_like_api_token", {
  looks_like_api_token <- quartzbio.edp:::looks_like_api_token

  expect_false(looks_like_api_token(""))
  expect_false(looks_like_api_token(NULL))
  expect_false(looks_like_api_token(NA))
  expect_false(looks_like_api_token(1))
  expect_false(looks_like_api_token(strrep("X", 40)))

  expect_true(looks_like_api_token(strrep("X", 30)))
  expect_true(looks_like_api_token(strrep(" ", 30)))
})


test_that("read_save_connection_from_file", {
  tmp <- setup_temp_dir()

  withr::with_envvar(c(HOME = tmp, USERPROFILE = tmp), {
    ### nothing saved yet
    expect_error(read_connection_profile(), "no such profile")
    expect_error(read_connection_profile("toto.json"), "no such profile")
    expect_error(
      read_connection_profile("toto.json", profile = "titi"),
      "no such profile"
    )

    ### standard
    conn <- list(secret = strrep("X", 30), host = "host")
    save_connection_profile(conn)

    expect_identical(read_connection_profile(), conn)

    ### add profile
    conn2 <- list(secret = strrep("Y", 40), host = "host2")

    save_connection_profile(conn2, profile = "with_key")

    expect_identical(read_connection_profile(), conn)
    expect_identical(read_connection_profile(profile = "with_key"), conn2)

    ### overwrite
    conn3 <- list(secret = strrep("Z", 40), host = "host3")
    expect_error(
      save_connection_profile(conn3, profile = "with_key"),
      "overwrite"
    )

    save_connection_profile(conn3, profile = "with_key", overwrite = TRUE)

    expect_identical(read_connection_profile(profile = "with_key"), conn3)

    ### custom path
    save_connection_profile(
      conn3,
      path = "custom.creds",
      profile = "with_token"
    )
    expect_identical(
      read_connection_profile(path = "custom.creds", profile = "with_token"),
      conn3
    )
  })
})


test_that("connect", {
  ### explicit usage
  key <- strrep("X", 40)
  token <- strrep("Y", 30)

  expect_identical(
    connect(token, "host", check = FALSE),
    list(secret = token, host = "host")
  )
  expect_error(connect(key, "host", check = FALSE))

  ### test env vars: KEY
  ALL_ENVS <- c(
    EDP_API_SECRET = "",
    SOLVEBIO_ACCESS_TOKEN = "",
    EDP_API_HOST = "",
    SOLVEBIO_API_HOST = ""
  )
  we <- function(envs, ...) {
    missing_envs <- setdiff(names(ALL_ENVS), names(envs))
    envs <- c(envs, ALL_ENVS[missing_envs])
    withr::with_envvar(envs, ...)
  }

  # new EDP env vars
  we(c(EDP_API_SECRET = token, EDP_API_HOST = "h"), {
    expect_identical(connect(check = FALSE), list(secret = token, host = "h"))
  })

  # backwards compatibility:
  we(
    c(
      SOLVEBIO_API_KEY = key,
      SOLVEBIO_ACCESS_TOKEN = token,
      SOLVEBIO_API_HOST = "h"
    ),
    {
      expect_identical(connect(check = FALSE), list(secret = token, host = "h"))
    }
  )
  we(
    c(SOLVEBIO_API_KEY = key, EDP_API_SECRET = token, SOLVEBIO_API_HOST = "h"),
    {
      expect_identical(connect(check = FALSE), list(secret = token, host = "h"))
    }
  )

  # precedence of new envs
  we(
    c(
      SOLVEBIO_API_KEY = "k2",
      EDP_API_SECRET = token,
      SOLVEBIO_API_HOST = "h2",
      EDP_API_HOST = "h"
    ),
    {
      expect_identical(connect(check = FALSE), list(secret = token, host = "h"))
    }
  )

  # explicit params (token) supersedes api_key via default
  we(c(EDP_API_SECRET = key, EDP_API_HOST = "h"), {
    expect_identical(
      connect(token, check = FALSE),
      list(secret = token, host = "h")
    )
  })

  # backwards compatibility:
  we(c(SOLVEBIO_ACCESS_TOKEN = token, SOLVEBIO_API_HOST = "h"), {
    expect_identical(connect(check = FALSE), list(secret = token, host = "h"))
  })

  # precedence of new envs
  we(
    c(
      SOLVEBIO_ACCESS_TOKEN = "t2",
      EDP_API_SECRET = token,
      SOLVEBIO_API_HOST = "h2",
      EDP_API_HOST = "h"
    ),
    {
      expect_identical(connect(check = FALSE), list(secret = token, host = "h"))
    }
  )
})
