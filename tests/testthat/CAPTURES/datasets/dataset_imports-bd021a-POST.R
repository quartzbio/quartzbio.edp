structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_imports",
  status_code = 201L, headers = structure(list(
    date = "Mon, 29 May 2023 08:42:49 GMT",
    `content-type` = "application/json", `content-length` = "936",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.1.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Mon, 29 May 2023 08:42:49 GMT",
      `content-type` = "application/json", `content-length` = "936",
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
  content = charToRaw("{\"annotator_params\": {\"annotator\": \"simple\", \"block_size\": 10, \"chunk_size\": 1000, \"data\": {}, \"debug\": false, \"include_errors\": true, \"keep_order\": true, \"pool_size\": 100, \"timeout\": 900, \"pre_annotation_expression\": \"\", \"post_annotation_expression\": \"\"}, \"class_name\": \"DatasetImport\", \"commit_mode\": \"append\", \"created_at\": \"2023-05-29T08:42:49.276Z\", \"dataset\": {\"availability\": \"available\", \"beacon_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/beacon\", \"capacity\": \"small\", \"changelog_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/changelog\", \"class_name\": \"Dataset\", \"commits_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/commits\", \"created_at\": \"2023-05-29T08:42:46.749Z\", \"data_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/data\", \"description\": \"my_dataset\", \"documents_count\": null, \"entity_types\": [], \"exports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/exports\", \"fields_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/fields\", \"full_path\": \"vsim-dev:quartzbio.edp.test.datasets:/toto/titi/my_dataset\", \"health\": \"green\", \"id\": \"2054312777863118640\", \"imports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/imports\", \"metadata\": {}, \"replicas\": 0, \"status\": \"open\", \"storage_class\": \"Temporary\", \"tags\": [], \"template_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640/template\", \"updated_at\": \"2023-05-29T08:42:47.027Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312777863118640\", \"vault_id\": 2420, \"vault_name\": \"quartzbio.edp.test.datasets\", \"vault_object_filename\": \"my_dataset\", \"vault_object_id\": \"2054312777863118640\", \"vault_object_path\": \"/toto/titi/my_dataset\"}, \"dataset_commits\": [], \"dataset_id\": \"2054312777863118640\", \"description\": null, \"entity_params\": {\"disable\": null, \"entity_types\": {}, \"sample_rate\": null, \"sample_count\": null, \"apply_detection\": null}, \"error_message\": null, \"genome_build\": null, \"id\": \"2054312798944152331\", \"import_messages\": {}, \"logical_object\": null, \"manifest\": {}, \"metadata\": {}, \"object_id\": null, \"reader_params\": {}, \"source\": \"data_records\", \"status\": \"queued\", \"tags\": [], \"task_id\": \"2054312799138272243\", \"target_fields\": [], \"timestamps\": [[\"new\", \"queued\", \"2023-05-29T08:42:49.285850Z\"]], \"title\": null, \"updated_at\": \"2023-05-29T08:42:49.287Z\", \"upload\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"validation_params\": {\"disable\": null, \"raise_on_errors\": null, \"strict_validation\": null, \"allow_new_fields\": null}, \"vault_id\": 2420}"),
  date = structure(1685349769, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 1.9e-05,
    connect = 2e-05, pretransfer = 7.5e-05, starttransfer = 8.4e-05,
    total = 0.313123
  )
), class = "response")
