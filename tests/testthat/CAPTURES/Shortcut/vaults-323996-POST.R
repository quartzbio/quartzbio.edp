structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults",
    status_code = 201L,
    headers = structure(
      list(
        date = "Mon, 19 Jan 2026 10:54:24 GMT",
        `content-type` = "application/json",
        `content-length` = "559",
        location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/3181",
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
          date = "Mon, 19 Jan 2026 10:54:24 GMT",
          `content-type` = "application/json",
          `content-length` = "559",
          location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/3181",
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
      "{\n  \"account_domain\": \"vsim-test-dev\",\n  \"account_id\": 33,\n  \"class_name\": \"Vault\",\n  \"created_at\": \"2026-01-19T10:54:24.159211Z\",\n  \"default_storage_class\": \"Temporary\",\n  \"description\": \"quartzbio.edp R package temp test vault\",\n  \"full_path\": \"vsim-test-dev:quartzbio.edp.test.Shortcut\",\n  \"has_children\": false,\n  \"has_folder_children\": false,\n  \"id\": 3181,\n  \"is_deleted\": false,\n  \"is_public\": false,\n  \"versioning\": \"disabled\",\n  \"last_synced\": {},\n  \"metadata\": {},\n  \"name\": \"quartzbio.edp.test.Shortcut\",\n  \"permissions\": {\n    \"read\": true,\n    \"write\": true,\n    \"admin\": true\n  },\n  \"provider\": \"EDP\",\n  \"require_unique_paths\": true,\n  \"tags\": [\n    \"TESTING\"\n  ],\n  \"updated_at\": \"2026-01-19T10:54:24.219935Z\",\n  \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/3181\",\n  \"user\": {\n    \"class_name\": \"User\",\n    \"date_joined\": \"2023-01-27T16:17:17.087Z\",\n    \"email\": \"Test.User@fakemail.com\",\n    \"first_name\": \"Test\",\n    \"full_name\": \"Test User\",\n    \"id\": 51,\n    \"is_active\": true,\n    \"is_staff\": false,\n    \"is_verified\": true,\n    \"last_name\": \"User\",\n    \"password_days_remaining\": {},\n    \"role\": \"member\",\n    \"title\": \"\",\n    \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v1/users/51\",\n    \"username\": \"mock_user\"\n  },\n  \"user_id\": 243,\n  \"vault_properties\": {},\n  \"vault_type\": \"general\",\n  \"bdm_settings\": {},\n  \"connection\": {},\n  \"connection_data\": {},\n  \"last_sync_time\": {},\n  \"is_favourite\": false\n}"
    ),
    date = structure(1768820064, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 3e-05,
      connect = 0,
      pretransfer = 0.000128,
      starttransfer = 0.302785,
      total = 0.30288
    )
  ),
  class = "response"
)
