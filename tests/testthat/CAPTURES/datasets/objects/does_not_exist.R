structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects/does_not_exist",
  status_code = 404L, headers = structure(list(
    date = "Mon, 29 May 2023 08:42:48 GMT",
    `content-type` = "application/json", `content-length` = "23",
    server = "nginx", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin", `solvebio-version` = "4.1.0-qb-dev",
    `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 404L, version = "HTTP/2",
    headers = structure(list(
      date = "Mon, 29 May 2023 08:42:48 GMT",
      `content-type` = "application/json", `content-length` = "23",
      server = "nginx", `strict-transport-security` = "max-age=31536000; includeSubDomains",
      vary = "Authorization, Origin", `solvebio-version` = "4.1.0-qb-dev",
      `x-frame-options` = "SAMEORIGIN"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = logical(0),
    flag = logical(0), path = logical(0), secure = logical(0),
    expiration = structure(numeric(0), class = c(
      "POSIXct",
      "POSIXt"
    )), name = logical(0), value = logical(0)
  ), row.names = integer(0), class = "data.frame"),
  content = charToRaw("{\"detail\": \"Not found\"}"), date = structure(1685349768, class = c(
    "POSIXct",
    "POSIXt"
  ), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 6.3e-05,
    connect = 6.7e-05, pretransfer = 0.000247, starttransfer = 0.155904,
    total = 0.156023
  )
), class = "response")
