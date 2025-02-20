structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults", status_code = 201L,
  headers = structure(list(
    date = "Tue, 26 Sep 2023 10:00:35 GMT", `content-type` = "application/json",
    `content-length` = "523", location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/3314",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.2.1-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(status = 201L, version = "HTTP/2", headers = structure(list(
    date = "Tue, 26 Sep 2023 10:00:35 GMT",
    `content-type` = "application/json", `content-length` = "523", location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/3314",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.2.1-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )))), cookies = structure(
    list(
      domain = logical(0), flag = logical(0),
      path = logical(0), secure = logical(0), expiration = structure(numeric(0),
        class = c("POSIXct", "POSIXt")
      ), name = logical(0), value = logical(0)
    ),
    row.names = integer(0), class = "data.frame"
  ), content = charToRaw("{\"account_domain\": \"vsim-dev\", \"account_id\": 3, \"class_name\": \"Vault\", \"created_at\": \"2023-09-26T10:00:35.514Z\", \"default_storage_class\": \"Temporary\", \"description\": \"quartzbio.edp R package temp test vault\", \"full_path\": \"vsim-dev:quartzbio.edp.test.dataset_import\", \"has_children\": false, \"has_folder_children\": false, \"id\": 3314, \"is_deleted\": false, \"is_public\": false, \"versioning\": \"disabled\", \"last_synced\": null, \"metadata\": {}, \"name\": \"quartzbio.edp.test.dataset_import\", \"permissions\": {\"read\": true, \"write\": true, \"admin\": true}, \"provider\": \"SolveBio\", \"require_unique_paths\": true, \"tags\": [\"TESTING\"], \"updated_at\": \"2023-09-26T10:00:35.533Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/vaults/3314\", \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Marc\", \"full_name\": \"Marc Lamarine\", \"id\": 71, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 71, \"vault_properties\": [], \"vault_type\": \"general\"}"),
  date = structure(1695722435, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0,
    namelookup = 1.9e-05, connect = 2e-05, pretransfer = 8.4e-05, starttransfer = 8.7e-05,
    total = 0.144402
  )
), class = "response")
