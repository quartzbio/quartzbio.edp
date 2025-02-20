structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_fields",
  status_code = 201L, headers = structure(list(
    date = "Thu, 13 Apr 2023 14:42:33 GMT",
    `content-type` = "application/json", `content-length` = "316",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_fields/11799",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "3.62.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Thu, 13 Apr 2023 14:42:33 GMT",
      `content-type` = "application/json", `content-length` = "316",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_fields/11799",
      server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
      vary = "Authorization, Origin, Accept-Encoding",
      `solvebio-version` = "3.62.0-qb-dev", allow = "GET, POST, HEAD, OPTIONS",
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
  content = charToRaw("{\"class_name\": \"DatasetField\", \"created_at\": \"2023-04-13T14:42:33.747Z\", \"depends_on\": [], \"data_type\": \"float\", \"dataset_id\": \"2021154175053945409\", \"description\": \"description\", \"entity_type\": null, \"expression\": null, \"facets_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_fields/11799/facets\", \"id\": 11799, \"is_hidden\": false, \"is_list\": null, \"is_read_only\": false, \"is_valid\": false, \"name\": \"name\", \"ordering\": 1, \"title\": \"title\", \"updated_at\": \"2023-04-13T14:42:33.749Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_fields/11799\", \"url_template\": null, \"vault_id\": 1921}"),
  date = structure(1681396953, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.001823,
    connect = 0.001826, pretransfer = 0.002804, starttransfer = 0.00281,
    total = 0.230341
  )
), class = "response")
