structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
    status_code = 201L,
    headers = structure(
      list(
        date = "Mon, 19 Jan 2026 10:55:39 GMT",
        `content-type` = "application/json",
        `content-length` = "606",
        location = "None",
        server = "nginx",
        allow = "GET, POST, HEAD, OPTIONS",
        `x-frame-options` = "SAMEORIGIN",
        vary = "Authorization, Origin, Accept-Encoding",
        `content-encoding` = "gzip",
        `strict-transport-security` = "max-age=31536000; includeSubDomains",
        `solvebio-version` = "7.3.0-qb-int-dev"
      ),
      class = c("insensitive", "list")
    ),
    all_headers = list(list(
      status = 201L,
      version = "HTTP/2",
      headers = structure(
        list(
          date = "Mon, 19 Jan 2026 10:55:39 GMT",
          `content-type` = "application/json",
          `content-length` = "606",
          location = "None",
          server = "nginx",
          allow = "GET, POST, HEAD, OPTIONS",
          `x-frame-options` = "SAMEORIGIN",
          vary = "Authorization, Origin, Accept-Encoding",
          `content-encoding` = "gzip",
          `strict-transport-security` = "max-age=31536000; includeSubDomains",
          `solvebio-version` = "7.3.0-qb-int-dev"
        ),
        class = c("insensitive", "list")
      )
    )),
    cookies = structure(
      list(
        domain = logical(0),
        flag = logical(0),
        path = logical(0),
        secure = logical(0),
        expiration = structure(numeric(0), class = c("POSIXct", "POSIXt")),
        name = logical(0),
        value = logical(0)
      ),
      row.names = integer(0),
      class = "data.frame"
    ),
    content = charToRaw(
      "{\n  \"account_id\": 33,\n  \"ancestor_object_ids\": [],\n  \"availability\": {},\n  \"class_name\": \"Object\",\n  \"created_at\": \"2026-01-19T10:55:38.983469Z\",\n  \"dataset_description\": {},\n  \"dataset_documents_count\": {},\n  \"documents_count\": {},\n  \"dataset_full_name\": {},\n  \"storage_class\": {},\n  \"dataset_id\": {},\n  \"depth\": 0,\n  \"description\": \"\",\n  \"filename\": \"test\",\n  \"full_path\": \"vsim-test-dev:quartzbio.edp.test.is_shortcut_works:/test\",\n  \"has_children\": false,\n  \"has_folder_children\": false,\n  \"id\": \"2754513010085670076\",\n  \"is_deleted\": false,\n  \"is_transformable\": false,\n  \"last_accessed\": \"2026-01-19T10:55:38.983400Z\",\n  \"last_modified\": \"2026-01-19T10:55:38.983400Z\",\n  \"md5\": {},\n  \"metadata\": {},\n  \"mimetype\": {},\n  \"num_children\": 0,\n  \"num_descendants\": 0,\n  \"object_type\": \"shortcut\",\n  \"parent_object_id\": {},\n  \"path\": \"/test\",\n  \"size\": {},\n  \"tags\": [],\n  \"updated_at\": \"2026-01-19T10:55:39.045741Z\",\n  \"upload_url\": {},\n  \"url\": {},\n  \"user\": {\n    \"class_name\": \"User\",\n    \"date_joined\": \"2023-01-27T16:17:17.087Z\",\n    \"email\": \"Test.User@fakemail.com\",\n    \"first_name\": \"Test\",\n    \"full_name\": \"Test User\",\n    \"id\": 51,\n    \"is_active\": true,\n    \"is_staff\": false,\n    \"is_verified\": true,\n    \"last_name\": \"User\",\n    \"password_days_remaining\": {},\n    \"role\": \"member\",\n    \"title\": \"\",\n    \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v1/users/51\",\n    \"username\": \"mock_user\"\n  },\n  \"user_id\": 243,\n  \"vault_id\": 3183,\n  \"vault_name\": \"quartzbio.edp.test.is_shortcut_works\",\n  \"version_count\": 1,\n  \"global_beacon\": {},\n  \"updated_by\": 243,\n  \"inherited_metadata\": {},\n  \"upload_id\": {},\n  \"upload_key\": {},\n  \"is_multipart\": false,\n  \"presigned_urls\": [],\n  \"target\": {\n    \"id\": {},\n    \"object_type\": \"url\",\n    \"url\": \"url\"\n  }\n}"
    ),
    date = structure(1768820139, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 2.4e-05,
      connect = 0,
      pretransfer = 0.000103,
      starttransfer = 0.230552,
      total = 0.230702
    )
  ),
  class = "response"
)
