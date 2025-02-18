structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_imports",
  status_code = 201L, headers = structure(list(
    date = "Tue, 26 Sep 2023 10:06:23 GMT",
    `content-type` = "application/json", `content-length` = "938",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.2.1-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 26 Sep 2023 10:06:23 GMT",
      `content-type` = "application/json", `content-length` = "938",
      server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
      vary = "Authorization, Origin, Accept-Encoding",
      `solvebio-version` = "4.2.1-qb-dev", allow = "GET, POST, HEAD, OPTIONS",
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
  content = charToRaw("{\"annotator_params\": {\"annotator\": \"simple\", \"block_size\": 10, \"chunk_size\": 1000, \"data\": {}, \"debug\": false, \"include_errors\": true, \"keep_order\": true, \"pool_size\": 100, \"timeout\": 900, \"pre_annotation_expression\": \"\", \"post_annotation_expression\": \"\"}, \"class_name\": \"DatasetImport\", \"commit_mode\": \"append\", \"created_at\": \"2023-09-26T10:06:23.120Z\", \"dataset\": {\"availability\": \"available\", \"beacon_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/beacon\", \"capacity\": \"small\", \"changelog_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/changelog\", \"class_name\": \"Dataset\", \"commits_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/commits\", \"created_at\": \"2023-09-26T10:06:22.489Z\", \"data_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/data\", \"description\": \"mtcars.ds\", \"documents_count\": null, \"entity_types\": [], \"exports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/exports\", \"fields_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/fields\", \"full_path\": \"vsim-dev:quartzbio.edp.test.ds_import_ff:/mtcars.ds\", \"health\": \"green\", \"id\": \"2141327940655504348\", \"imports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/imports\", \"metadata\": {}, \"replicas\": 0, \"status\": \"open\", \"storage_class\": \"Temporary\", \"tags\": [], \"template_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348/template\", \"updated_at\": \"2023-09-26T10:06:22.838Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2141327940655504348\", \"vault_id\": 3316, \"vault_name\": \"quartzbio.edp.test.ds_import_ff\", \"vault_object_filename\": \"mtcars.ds\", \"vault_object_id\": \"2141327940655504348\", \"vault_object_path\": \"/mtcars.ds\"}, \"dataset_commits\": [], \"dataset_id\": \"2141327940655504348\", \"description\": null, \"entity_params\": {\"disable\": null, \"entity_types\": {}, \"sample_rate\": null, \"sample_count\": null, \"apply_detection\": null}, \"error_message\": null, \"genome_build\": null, \"id\": \"2141327945862245395\", \"import_messages\": {}, \"logical_object\": \"2141327932658290318\", \"manifest\": {}, \"metadata\": {}, \"object_id\": \"2141327932658290318\", \"reader_params\": {}, \"source\": \"object\", \"status\": \"queued\", \"tags\": [], \"task_id\": \"2141327946002308558\", \"target_fields\": [], \"timestamps\": [[\"new\", \"queued\", \"2023-09-26T10:06:23.125785Z\"]], \"title\": null, \"updated_at\": \"2023-09-26T10:06:23.126Z\", \"upload\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 71, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"validation_params\": {\"disable\": null, \"raise_on_errors\": null, \"strict_validation\": null, \"allow_new_fields\": null}, \"vault_id\": 3316}"),
  date = structure(1695722783, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 5e-05,
    connect = 5.5e-05, pretransfer = 0.000188, starttransfer = 0.000193,
    total = 0.191503
  )
), class = "response")
