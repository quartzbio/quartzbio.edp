structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults",
    status_code = 201L,
    headers = structure(
      list(
        date = "Mon, 29 May 2023 08:42:45 GMT",
        `content-type` = "application/json",
        `content-length` = "521",
        location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/2420",
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
          date = "Mon, 29 May 2023 08:42:45 GMT",
          `content-type` = "application/json",
          `content-length` = "521",
          location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/2420",
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
      "{\"account_domain\": \"vsim-dev\", \"account_id\": 3, \"class_name\": \"Vault\", \"created_at\": \"2023-05-29T08:42:45.394Z\", \"default_storage_class\": \"Temporary\", \"description\": \"quartzbio.edp R package temp test vault\", \"full_path\": \"vsim-dev:quartzbio.edp.test.datasets\", \"has_children\": false, \"has_folder_children\": false, \"id\": 2420, \"is_deleted\": false, \"is_public\": false, \"versioning\": \"disabled\", \"last_synced\": null, \"metadata\": {}, \"name\": \"quartzbio.edp.test.datasets\", \"permissions\": {\"read\": true, \"write\": true, \"admin\": true}, \"provider\": \"SolveBio\", \"require_unique_paths\": true, \"tags\": [\"TESTING\"], \"updated_at\": \"2023-05-29T08:42:45.423Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/2420\", \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_properties\": [], \"vault_type\": \"general\"}"
    ),
    date = structure(1685349765, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 0.172447,
      connect = 0.315888,
      pretransfer = 0.669128,
      starttransfer = 0.669199,
      total = 0.887847
    )
  ),
  class = "response"
)
