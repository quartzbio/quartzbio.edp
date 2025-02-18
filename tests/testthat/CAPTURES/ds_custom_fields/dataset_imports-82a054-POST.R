structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_imports",
  status_code = 201L, headers = structure(list(
    date = "Mon, 29 May 2023 13:49:53 GMT",
    `content-type` = "application/json", `content-length` = "1107",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.1.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Mon, 29 May 2023 13:49:53 GMT",
      `content-type` = "application/json", `content-length` = "1107",
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
  content = charToRaw("{\"annotator_params\": {\"annotator\": \"simple\", \"block_size\": 10, \"chunk_size\": 1000, \"data\": {}, \"debug\": false, \"include_errors\": true, \"keep_order\": true, \"pool_size\": 100, \"timeout\": 900, \"pre_annotation_expression\": \"\", \"post_annotation_expression\": \"\"}, \"class_name\": \"DatasetImport\", \"commit_mode\": \"append\", \"created_at\": \"2023-05-29T13:49:53.815Z\", \"dataset\": {\"availability\": \"available\", \"beacon_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/beacon\", \"capacity\": \"small\", \"changelog_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/changelog\", \"class_name\": \"Dataset\", \"commits_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/commits\", \"created_at\": \"2023-05-29T13:49:53.270Z\", \"data_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/data\", \"description\": \"iris.ds\", \"documents_count\": null, \"entity_types\": [], \"exports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/exports\", \"fields_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/fields\", \"full_path\": \"vsim-dev:quartzbio.edp.test.ds_custom_fields:/A/custom/iris.ds\", \"health\": \"green\", \"id\": \"2054467350719965339\", \"imports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/imports\", \"metadata\": {}, \"replicas\": 0, \"status\": \"open\", \"storage_class\": \"Temporary\", \"tags\": [], \"template_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339/template\", \"updated_at\": \"2023-05-29T13:49:53.607Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467350719965339\", \"vault_id\": 2453, \"vault_name\": \"quartzbio.edp.test.ds_custom_fields\", \"vault_object_filename\": \"iris.ds\", \"vault_object_id\": \"2054467350719965339\", \"vault_object_path\": \"/A/custom/iris.ds\"}, \"dataset_commits\": [], \"dataset_id\": \"2054467350719965339\", \"description\": null, \"entity_params\": {\"disable\": null, \"entity_types\": {}, \"sample_rate\": null, \"sample_count\": null, \"apply_detection\": null}, \"error_message\": null, \"genome_build\": null, \"id\": \"2054467355184445049\", \"import_messages\": {}, \"logical_object\": null, \"manifest\": {}, \"metadata\": {}, \"object_id\": null, \"reader_params\": {}, \"source\": \"data_records\", \"status\": \"queued\", \"tags\": [], \"task_id\": \"2054467355400697911\", \"target_fields\": [{\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Petal.Length\", \"ordering\": 2, \"title\": \"petal_length\", \"url_template\": null}, {\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Petal.Width\", \"ordering\": 1, \"title\": \"petal_width\", \"url_template\": null}, {\"data_type\": \"integer\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Sepal.Length\", \"ordering\": 4, \"title\": \"sepal_length\", \"url_template\": null}, {\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Sepal.Width\", \"ordering\": 3, \"title\": \"sepal_width\", \"url_template\": null}, {\"data_type\": \"string\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Species\", \"ordering\": 0, \"title\": \"species\", \"url_template\": null}], \"timestamps\": [[\"new\", \"queued\", \"2023-05-29T13:49:53.825390Z\"]], \"title\": null, \"updated_at\": \"2023-05-29T13:49:53.826Z\", \"upload\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"validation_params\": {\"disable\": null, \"raise_on_errors\": null, \"strict_validation\": null, \"allow_new_fields\": null}, \"vault_id\": 2453}"),
  date = structure(1685368193, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 2.6e-05,
    connect = 2.7e-05, pretransfer = 9.8e-05, starttransfer = 0.000109,
    total = 0.300855
  )
), class = "response")
