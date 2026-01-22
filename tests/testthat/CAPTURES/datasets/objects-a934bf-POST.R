structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
    status_code = 201L,
    headers = structure(
      list(
        date = "Mon, 29 May 2023 08:42:47 GMT",
        `content-type` = "application/json",
        `content-length` = "604",
        location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
        server = "nginx",
        `content-encoding` = "gzip",
        `strict-transport-security` = "max-age=31536000; includeSubDomains",
        vary = "Authorization, Origin, Accept-Encoding",
        `solvebio-version` = "4.1.0-qb-dev",
        allow = "GET, POST, HEAD, OPTIONS",
        `x-frame-options` = "SAMEORIGIN"
      ),
      class = c(
        "insensitive",
        "list"
      )
    ),
    all_headers = list(list(
      status = 201L,
      version = "HTTP/2",
      headers = structure(
        list(
          date = "Mon, 29 May 2023 08:42:47 GMT",
          `content-type` = "application/json",
          `content-length` = "604",
          location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
          server = "nginx",
          `content-encoding` = "gzip",
          `strict-transport-security` = "max-age=31536000; includeSubDomains",
          vary = "Authorization, Origin, Accept-Encoding",
          `solvebio-version` = "4.1.0-qb-dev",
          allow = "GET, POST, HEAD, OPTIONS",
          `x-frame-options` = "SAMEORIGIN"
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
      "{\"account_id\": 3, \"ancestor_object_ids\": [\"2054312773621907015\", \"2054312775707888678\"], \"availability\": \"available\", \"class_name\": \"Object\", \"created_at\": \"2023-05-29T08:42:46.759Z\", \"dataset_description\": \"my_dataset\", \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": \"2054312777863118640\", \"storage_class\": \"Temporary\", \"dataset_id\": \"2054312777863118640\", \"depth\": 2, \"description\": \"my_dataset\", \"filename\": \"my_dataset\", \"full_path\": \"vsim-dev:quartzbio.edp.test.datasets:/toto/titi/my_dataset\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2054312777863118640\", \"is_deleted\": false, \"is_transformable\": false, \"last_accessed\": \"2023-05-29T08:42:46.758Z\", \"last_modified\": \"2023-05-29T08:42:46.758Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"application/vnd.solvebio.dataset\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"dataset\", \"parent_object_id\": \"2054312775707888678\", \"path\": \"/toto/titi/my_dataset\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-05-29T08:42:47.052Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 2420, \"vault_name\": \"quartzbio.edp.test.datasets\", \"version_count\": 0, \"global_beacon\": null}"
    ),
    date = structure(1685349767, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 9.4e-05,
      connect = 9.8e-05,
      pretransfer = 0.000295,
      starttransfer = 0.000303,
      total = 0.493136
    )
  ),
  class = "response"
)
