structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Mon, 29 May 2023 08:42:46 GMT",
    `content-type` = "application/json", `content-length` = "572",
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
      date = "Mon, 29 May 2023 08:42:46 GMT",
      `content-type` = "application/json", `content-length` = "572",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [\"2054312773621907015\"], \"availability\": null, \"class_name\": \"Object\", \"created_at\": \"2023-05-29T08:42:46.501Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 1, \"description\": null, \"filename\": \"titi\", \"full_path\": \"vsim-dev:quartzbio.edp.test.datasets:/toto/titi\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2054312775707888678\", \"is_deleted\": false, \"is_transformable\": false, \"last_accessed\": \"2023-05-29T08:42:46.501Z\", \"last_modified\": \"2023-05-29T08:42:46.501Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"application/vnd.solvebio.folder\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"folder\", \"parent_object_id\": \"2054312773621907015\", \"path\": \"/toto/titi\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-05-29T08:42:46.528Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 2420, \"vault_name\": \"quartzbio.edp.test.datasets\", \"version_count\": 0, \"global_beacon\": null}"),
  date = structure(1685349766, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 9.3e-05,
    connect = 0.000102, pretransfer = 0.000336, starttransfer = 0.000349,
    total = 0.242691
  )
), class = "response")
