structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v1/user",
    status_code = 401L,
    headers = structure(
      list(
        date = "Wed, 15 Mar 2023 18:18:25 GMT",
        `content-type` = "application/json",
        `content-length` = "59",
        server = "nginx",
        `strict-transport-security` = "max-age=31536000; includeSubDomains",
        vary = "Authorization, Origin",
        `solvebio-version` = "3.62.0-qb-dev",
        allow = "GET, HEAD, OPTIONS",
        `x-frame-options` = "SAMEORIGIN",
        `www-authenticate` = "Bearer realm=\"api\""
      ),
      class = c(
        "insensitive",
        "list"
      )
    ),
    all_headers = list(list(
      status = 401L,
      version = "HTTP/2",
      headers = structure(
        list(
          date = "Wed, 15 Mar 2023 18:18:25 GMT",
          `content-type` = "application/json",
          `content-length` = "59",
          server = "nginx",
          `strict-transport-security` = "max-age=31536000; includeSubDomains",
          vary = "Authorization, Origin",
          `solvebio-version` = "3.62.0-qb-dev",
          allow = "GET, HEAD, OPTIONS",
          `x-frame-options` = "SAMEORIGIN",
          `www-authenticate` = "Bearer realm=\"api\""
        ),
        class = c(
          "insensitive",
          "list"
        )
      )
    )),
    cookies = structure(
      list(
        domain = logical(0),
        flag = logical(0),
        path = logical(0),
        secure = logical(0),
        expiration = structure(
          numeric(0),
          class = c(
            "POSIXct",
            "POSIXt"
          )
        ),
        name = logical(0),
        value = logical(0)
      ),
      row.names = integer(0),
      class = "data.frame"
    ),
    content = charToRaw(
      "{\n  \"detail\": \"Authentication credentials were not provided.\"\n}"
    ),
    date = structure(1678904305, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 4.7e-05,
      connect = 5e-05,
      pretransfer = 0.000175,
      starttransfer = 0.108838,
      total = 0.108958
    )
  ),
  class = "response"
)
