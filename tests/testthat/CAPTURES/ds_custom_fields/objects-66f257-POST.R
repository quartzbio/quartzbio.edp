structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Mon, 29 May 2023 13:49:52 GMT",
    `content-type` = "application/json", `content-length` = "556",
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
      date = "Mon, 29 May 2023 13:49:52 GMT",
      `content-type` = "application/json", `content-length` = "556",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [], \"availability\": null, \"class_name\": \"Object\", \"created_at\": \"2023-05-29T13:49:52.780Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 0, \"description\": null, \"filename\": \"A\", \"full_path\": \"vsim-dev:quartzbio.edp.test.ds_custom_fields:/A\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2054467346531397370\", \"is_deleted\": false, \"is_transformable\": false, \"last_accessed\": \"2023-05-29T13:49:52.780Z\", \"last_modified\": \"2023-05-29T13:49:52.780Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"application/vnd.solvebio.folder\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"folder\", \"parent_object_id\": null, \"path\": \"/A\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-05-29T13:49:52.801Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 2453, \"vault_name\": \"quartzbio.edp.test.ds_custom_fields\", \"version_count\": 0, \"global_beacon\": null}"),
  date = structure(1685368192, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 2.6e-05,
    connect = 2.7e-05, pretransfer = 0.00011, starttransfer = 0.000113,
    total = 0.207549
  )
), class = "response")
