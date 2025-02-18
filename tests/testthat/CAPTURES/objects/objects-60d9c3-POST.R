structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Thu, 13 Apr 2023 15:49:58 GMT",
    `content-type` = "application/json", `content-length` = "598",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "3.62.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Thu, 13 Apr 2023 15:49:58 GMT",
      `content-type` = "application/json", `content-length` = "598",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [\"2021188097437023585\"], \"availability\": \"available\", \"class_name\": \"Object\", \"created_at\": \"2023-04-13T15:49:57.805Z\", \"dataset_description\": \"data.csv\", \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": \"2021188103040728441\", \"storage_class\": \"Temporary\", \"dataset_id\": \"2021188103040728441\", \"depth\": 1, \"description\": \"data.csv\", \"filename\": \"data.csv\", \"full_path\": \"vsim-dev:quartzbio.edp.test.objects:/dir1/data.csv\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2021188103040728441\", \"is_deleted\": false, \"is_transformable\": true, \"last_accessed\": \"2023-04-13T15:49:57.805Z\", \"last_modified\": \"2023-04-13T15:49:57.805Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"text/csv\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"dataset\", \"parent_object_id\": \"2021188097437023585\", \"path\": \"/dir1/data.csv\", \"size\": null, \"tags\": [\"quartzbio.edp.objects.hopefully.this.is.unique\", \"misc\"], \"updated_at\": \"2023-04-13T15:49:58.117Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 1940, \"vault_name\": \"quartzbio.edp.test.objects\", \"global_beacon\": null}"),
  date = structure(1681400998, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.4e-05,
    connect = 3.5e-05, pretransfer = 0.000111, starttransfer = 0.000114,
    total = 0.477731
  )
), class = "response")
