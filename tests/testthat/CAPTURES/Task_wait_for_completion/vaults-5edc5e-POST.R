structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults",
    status_code = 201L,
    headers = structure(
      list(
        date = "Tue, 14 Feb 2023 08:29:36 GMT",
        `content-type` = "application/json",
        `content-length` = "517",
        location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/1291",
        server = "nginx/1.21.1",
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
          date = "Tue, 14 Feb 2023 08:29:36 GMT",
          `content-type` = "application/json",
          `content-length` = "517",
          location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/1291",
          server = "nginx/1.21.1",
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
      "{\"account_domain\": \"vsim-dev\", \"account_id\": 3, \"class_name\": \"Vault\", \"created_at\": \"2023-02-14T08:29:36.847Z\", \"default_storage_class\": \"Temporary\", \"description\": \"quartzbio.edp R package temp test vault\", \"full_path\": \"vsim-dev:quartzbio.edp.test.Task_wait_for_completion\", \"has_children\": false, \"has_folder_children\": false, \"id\": 1291, \"is_deleted\": false, \"is_public\": false, \"last_synced\": null, \"metadata\": {}, \"name\": \"quartzbio.edp.test.Task_wait_for_completion\", \"permissions\": {\"read\": true, \"write\": true, \"admin\": true}, \"provider\": \"SolveBio\", \"require_unique_paths\": true, \"tags\": [\"TESTING\"], \"updated_at\": \"2023-02-14T08:29:36.970Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/1291\", \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_properties\": [], \"vault_type\": \"general\"}"
    ),
    date = structure(1676363376, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 1.8e-05,
      connect = 1.9e-05,
      pretransfer = 6.3e-05,
      starttransfer = 6.5e-05,
      total = 0.249661
    )
  ),
  class = "response"
)
