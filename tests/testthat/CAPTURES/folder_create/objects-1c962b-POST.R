structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
    status_code = 201L,
    headers = structure(
      list(
        date = "Thu, 13 Apr 2023 14:30:34 GMT",
        `content-type` = "application/json",
        `content-length` = "587",
        location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
        server = "nginx",
        `content-encoding` = "gzip",
        `strict-transport-security` = "max-age=31536000; includeSubDomains",
        vary = "Authorization, Origin, Accept-Encoding",
        `solvebio-version` = "3.62.0-qb-dev",
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
          date = "Thu, 13 Apr 2023 14:30:34 GMT",
          `content-type` = "application/json",
          `content-length` = "587",
          location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
          server = "nginx",
          `content-encoding` = "gzip",
          `strict-transport-security` = "max-age=31536000; includeSubDomains",
          vary = "Authorization, Origin, Accept-Encoding",
          `solvebio-version` = "3.62.0-qb-dev",
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
      "{\"account_id\": 3, \"ancestor_object_ids\": [\"2021148127732252627\", \"2021148133552978287\", \"2021148140150635013\"], \"availability\": null, \"class_name\": \"Object\", \"created_at\": \"2023-04-13T14:30:34.039Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 3, \"description\": null, \"filename\": \"d4\", \"full_path\": \"vsim-dev:quartzbio.edp.test.folder_create:/d1/d2/d3/d4\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2021148141663119769\", \"is_deleted\": false, \"is_transformable\": false, \"last_accessed\": \"2023-04-13T14:30:34.039Z\", \"last_modified\": \"2023-04-13T14:30:34.039Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"application/vnd.solvebio.folder\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"folder\", \"parent_object_id\": \"2021148140150635013\", \"path\": \"/d1/d2/d3/d4\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-04-13T14:30:34.063Z\", \"upload_url\": null, \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 1902, \"vault_name\": \"quartzbio.edp.test.folder_create\", \"global_beacon\": null}"
    ),
    date = structure(1681396234, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 4.6e-05,
      connect = 5.1e-05,
      pretransfer = 0.000161,
      starttransfer = 0.000167,
      total = 0.161597
    )
  ),
  class = "response"
)
