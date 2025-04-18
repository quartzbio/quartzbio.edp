structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Tue, 26 Sep 2023 10:06:22 GMT",
    `content-type` = "application/json", `content-length` = "571",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.2.1-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 26 Sep 2023 10:06:22 GMT",
      `content-type` = "application/json", `content-length` = "571",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
      server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
      vary = "Authorization, Origin, Accept-Encoding",
      `solvebio-version` = "4.2.1-qb-dev", allow = "GET, POST, HEAD, OPTIONS",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [], \"availability\": \"available\", \"class_name\": \"Object\", \"created_at\": \"2023-09-26T10:06:22.493Z\", \"dataset_description\": \"mtcars.ds\", \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": \"2141327940655504348\", \"storage_class\": \"Temporary\", \"dataset_id\": \"2141327940655504348\", \"depth\": 0, \"description\": \"mtcars.ds\", \"filename\": \"mtcars.ds\", \"full_path\": \"vsim-dev:quartzbio.edp.test.ds_import_ff:/mtcars.ds\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2141327940655504348\", \"is_deleted\": false, \"is_transformable\": false, \"last_accessed\": \"2023-09-26T10:06:22.493Z\", \"last_modified\": \"2023-09-26T10:06:22.493Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"application/vnd.solvebio.dataset\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"dataset\", \"parent_object_id\": null, \"path\": \"/mtcars.ds\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-09-26T10:06:22.860Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Marc\", \"full_name\": \"Marc Lamarine\", \"id\": 71, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 71, \"vault_id\": 3316, \"vault_name\": \"quartzbio.edp.test.ds_import_ff\", \"version_count\": 0, \"global_beacon\": null}"),
  date = structure(1695722782, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.1e-05,
    connect = 3.3e-05, pretransfer = 9.2e-05, starttransfer = 9.4e-05,
    total = 0.6037
  )
), class = "response")
