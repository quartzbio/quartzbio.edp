structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Mon, 29 May 2023 14:05:52 GMT",
    `content-type` = "application/json", `content-length` = "570",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.1.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Mon, 29 May 2023 14:05:52 GMT",
      `content-type` = "application/json", `content-length` = "570",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
      server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
      vary = "Authorization, Origin, Accept-Encoding",
      `solvebio-version` = "4.1.0-qb-dev", allow = "GET, POST, HEAD, OPTIONS",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [\"2054475395241159287\"], \"availability\": null, \"class_name\": \"Object\", \"created_at\": \"2023-05-29T14:05:52.491Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 1, \"description\": null, \"filename\": \"b\", \"full_path\": \"vsim-dev:quartzbio.edp.test.parallel:/A/b\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2054475397183957638\", \"is_deleted\": false, \"is_transformable\": false, \"last_accessed\": \"2023-05-29T14:05:52.491Z\", \"last_modified\": \"2023-05-29T14:05:52.491Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"application/vnd.solvebio.folder\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"folder\", \"parent_object_id\": \"2054475395241159287\", \"path\": \"/A/b\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-05-29T14:05:52.515Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 2455, \"vault_name\": \"quartzbio.edp.test.parallel\", \"version_count\": 0, \"global_beacon\": null}"),
  date = structure(1685369152, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 4.7e-05,
    connect = 4.9e-05, pretransfer = 0.000176, starttransfer = 0.000183,
    total = 0.179592
  )
), class = "response")
