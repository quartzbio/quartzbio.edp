structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_imports",
  status_code = 201L, headers = structure(list(
    date = "Tue, 14 Feb 2023 08:29:37 GMT",
    `content-type` = "application/json", `content-length` = "935",
    server = "nginx/1.21.1", `content-encoding` = "gzip",
    `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "3.62.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 14 Feb 2023 08:29:37 GMT",
      `content-type` = "application/json", `content-length` = "935",
      server = "nginx/1.21.1", `content-encoding` = "gzip",
      `strict-transport-security` = "max-age=31536000; includeSubDomains",
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
  content = charToRaw("{\"annotator_params\": {\"annotator\": \"simple\", \"block_size\": 10, \"chunk_size\": 1000, \"data\": {}, \"debug\": false, \"include_errors\": true, \"keep_order\": true, \"pool_size\": 100, \"timeout\": 900, \"pre_annotation_expression\": \"\", \"post_annotation_expression\": \"\"}, \"class_name\": \"DatasetImport\", \"commit_mode\": \"append\", \"created_at\": \"2023-02-14T08:29:37.791Z\", \"dataset\": {\"availability\": \"available\", \"beacon_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/beacon\", \"capacity\": \"small\", \"changelog_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/changelog\", \"class_name\": \"Dataset\", \"commits_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/commits\", \"created_at\": \"2023-02-14T08:29:37.340Z\", \"data_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/data\", \"description\": \"my_dataset\", \"documents_count\": null, \"entity_types\": [], \"exports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/exports\", \"fields_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/fields\", \"full_path\": \"vsim-dev:quartzbio.edp.test.Task_wait_for_completion:/my_dataset\", \"health\": \"green\", \"id\": \"1978929479725304116\", \"imports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/imports\", \"metadata\": {}, \"replicas\": 0, \"status\": \"open\", \"storage_class\": \"Temporary\", \"tags\": [], \"template_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116/template\", \"updated_at\": \"2023-02-14T08:29:37.584Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/1978929479725304116\", \"vault_id\": 1291, \"vault_name\": \"quartzbio.edp.test.Task_wait_for_completion\", \"vault_object_filename\": \"my_dataset\", \"vault_object_id\": \"1978929479725304116\", \"vault_object_path\": \"/my_dataset\"}, \"dataset_commits\": [], \"dataset_id\": \"1978929479725304116\", \"description\": null, \"entity_params\": {\"disable\": null, \"entity_types\": {}, \"sample_rate\": null, \"sample_count\": null, \"apply_detection\": null}, \"error_message\": null, \"genome_build\": null, \"id\": \"1978929483444397267\", \"import_messages\": {}, \"logical_object\": null, \"manifest\": {}, \"metadata\": {}, \"object_id\": null, \"reader_params\": {}, \"source\": \"data_records\", \"status\": \"queued\", \"tags\": [], \"task_id\": \"1\", \"target_fields\": [], \"timestamps\": [[\"new\", \"queued\", \"2023-02-14T08:29:37.796704Z\"]], \"title\": null, \"updated_at\": \"2023-02-14T08:29:37.797Z\", \"upload\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"validation_params\": {\"disable\": null, \"raise_on_errors\": null, \"strict_validation\": null, \"allow_new_fields\": null}, \"vault_id\": 1291}"),
  date = structure(1676363377, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 2.6e-05,
    connect = 2.7e-05, pretransfer = 9.4e-05, starttransfer = 9.7e-05,
    total = 0.213734
  )
), class = "response")
