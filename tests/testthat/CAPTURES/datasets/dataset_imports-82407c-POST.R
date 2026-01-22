structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_imports",
    status_code = 201L,
    headers = structure(
      list(
        date = "Mon, 29 May 2023 08:43:08 GMT",
        `content-type` = "application/json",
        `content-length` = "1180",
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
          date = "Mon, 29 May 2023 08:43:08 GMT",
          `content-type` = "application/json",
          `content-length` = "1180",
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
      "{\"annotator_params\": {\"annotator\": \"simple\", \"block_size\": 10, \"chunk_size\": 1000, \"data\": {}, \"debug\": false, \"include_errors\": true, \"keep_order\": true, \"pool_size\": 100, \"timeout\": 900, \"pre_annotation_expression\": \"\", \"post_annotation_expression\": \"\"}, \"class_name\": \"DatasetImport\", \"commit_mode\": \"append\", \"created_at\": \"2023-05-29T08:43:08.396Z\", \"dataset\": {\"availability\": \"available\", \"beacon_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/beacon\", \"capacity\": \"small\", \"changelog_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/changelog\", \"class_name\": \"Dataset\", \"commits_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/commits\", \"created_at\": \"2023-05-29T08:42:47.504Z\", \"data_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/data\", \"description\": \"description\", \"documents_count\": 0, \"entity_types\": [], \"exports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/exports\", \"fields_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/fields\", \"full_path\": \"vsim-dev:quartzbio.edp.test.datasets:/toto/titi/my_dataset2\", \"health\": \"green\", \"id\": \"2054312784203227481\", \"imports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/imports\", \"metadata\": {\"DEV\": true}, \"replicas\": 0, \"status\": \"open\", \"storage_class\": \"Temporary\", \"tags\": [\"QBP\", \"EDP\"], \"template_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481/template\", \"updated_at\": \"2023-05-29T08:42:50.907Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054312784203227481\", \"vault_id\": 2420, \"vault_name\": \"quartzbio.edp.test.datasets\", \"vault_object_filename\": \"my_dataset2\", \"vault_object_id\": \"2054312784203227481\", \"vault_object_path\": \"/toto/titi/my_dataset2\"}, \"dataset_commits\": [], \"dataset_id\": \"2054312784203227481\", \"description\": null, \"entity_params\": {\"disable\": null, \"entity_types\": {}, \"sample_rate\": null, \"sample_count\": null, \"apply_detection\": null}, \"error_message\": null, \"genome_build\": null, \"id\": \"2054312959325305311\", \"import_messages\": {}, \"logical_object\": null, \"manifest\": {}, \"metadata\": {}, \"object_id\": null, \"reader_params\": {}, \"source\": \"data_records\", \"status\": \"queued\", \"tags\": [], \"task_id\": \"2054312959475817460\", \"target_fields\": [{\"data_type\": \"auto\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"arbitrary\", \"ordering\": 6, \"title\": \"arbitrary\", \"url_template\": null}, {\"data_type\": \"string\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"character\", \"ordering\": 1, \"title\": \"character\", \"url_template\": null}, {\"data_type\": \"date\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"date\", \"ordering\": 5, \"title\": \"date\", \"url_template\": null}, {\"data_type\": \"string\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"factor\", \"ordering\": 4, \"title\": \"factor\", \"url_template\": null}, {\"data_type\": \"integer\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"integer\", \"ordering\": 3, \"title\": \"integer\", \"url_template\": null}, {\"data_type\": \"boolean\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"logical\", \"ordering\": 0, \"title\": \"logical\", \"url_template\": null}, {\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"numeric\", \"ordering\": 2, \"title\": \"numeric\", \"url_template\": null}], \"timestamps\": [[\"new\", \"queued\", \"2023-05-29T08:43:08.402104Z\"]], \"title\": null, \"updated_at\": \"2023-05-29T08:43:08.403Z\", \"upload\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"validation_params\": {\"disable\": null, \"raise_on_errors\": null, \"strict_validation\": null, \"allow_new_fields\": null}, \"vault_id\": 2420}"
    ),
    date = structure(1685349788, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 3.6e-05,
      connect = 3.8e-05,
      pretransfer = 0.000136,
      starttransfer = 0.00016,
      total = 0.270546
    )
  ),
  class = "response"
)
