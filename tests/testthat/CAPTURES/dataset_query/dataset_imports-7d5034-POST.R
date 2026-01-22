structure(
  list(
    url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/dataset_imports",
    status_code = 201L,
    headers = structure(
      list(
        date = "Mon, 29 May 2023 13:50:15 GMT",
        `content-type` = "application/json",
        `content-length` = "1090",
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
          date = "Mon, 29 May 2023 13:50:15 GMT",
          `content-type` = "application/json",
          `content-length` = "1090",
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
      "{\"annotator_params\": {\"annotator\": \"simple\", \"block_size\": 10, \"chunk_size\": 1000, \"data\": {}, \"debug\": false, \"include_errors\": true, \"keep_order\": true, \"pool_size\": 100, \"timeout\": 900, \"pre_annotation_expression\": \"\", \"post_annotation_expression\": \"\"}, \"class_name\": \"DatasetImport\", \"commit_mode\": \"append\", \"created_at\": \"2023-05-29T13:50:14.937Z\", \"dataset\": {\"availability\": \"available\", \"beacon_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/beacon\", \"capacity\": \"small\", \"changelog_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/changelog\", \"class_name\": \"Dataset\", \"commits_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/commits\", \"created_at\": \"2023-05-29T13:50:14.282Z\", \"data_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/data\", \"description\": \"iris.ds\", \"documents_count\": null, \"entity_types\": [], \"exports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/exports\", \"fields_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/fields\", \"full_path\": \"vsim-dev:quartzbio.edp.test.dataset_query:/A/b/iris.ds\", \"health\": \"green\", \"id\": \"2054467527007381804\", \"imports_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/imports\", \"metadata\": {}, \"replicas\": 0, \"status\": \"open\", \"storage_class\": \"Temporary\", \"tags\": [], \"template_url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804/template\", \"updated_at\": \"2023-05-29T13:50:14.555Z\", \"url\": \"https://vsim-dev.api.edp.aws.quartz.bio/v2/datasets/2054467527007381804\", \"vault_id\": 2454, \"vault_name\": \"quartzbio.edp.test.dataset_query\", \"vault_object_filename\": \"iris.ds\", \"vault_object_id\": \"2054467527007381804\", \"vault_object_path\": \"/A/b/iris.ds\"}, \"dataset_commits\": [], \"dataset_id\": \"2054467527007381804\", \"description\": null, \"entity_params\": {\"disable\": null, \"entity_types\": {}, \"sample_rate\": null, \"sample_count\": null, \"apply_detection\": null}, \"error_message\": null, \"genome_build\": null, \"id\": \"2054467532364425511\", \"import_messages\": {}, \"logical_object\": null, \"manifest\": {}, \"metadata\": {}, \"object_id\": null, \"reader_params\": {}, \"source\": \"data_records\", \"status\": \"queued\", \"tags\": [], \"task_id\": \"2054467532505997548\", \"target_fields\": [{\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Petal.Length\", \"ordering\": 2, \"title\": \"Petal.Length\", \"url_template\": null}, {\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Petal.Width\", \"ordering\": 3, \"title\": \"Petal.Width\", \"url_template\": null}, {\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Sepal.Length\", \"ordering\": 0, \"title\": \"Sepal.Length\", \"url_template\": null}, {\"data_type\": \"double\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Sepal.Width\", \"ordering\": 1, \"title\": \"Sepal.Width\", \"url_template\": null}, {\"data_type\": \"string\", \"depends_on\": [], \"description\": \"\", \"entity_type\": null, \"expression\": null, \"is_hidden\": false, \"is_list\": null, \"is_transient\": false, \"name\": \"Species\", \"ordering\": 4, \"title\": \"Species\", \"url_template\": null}], \"timestamps\": [[\"new\", \"queued\", \"2023-05-29T13:50:14.942636Z\"]], \"title\": null, \"updated_at\": \"2023-05-29T13:50:14.943Z\", \"upload\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"validation_params\": {\"disable\": null, \"raise_on_errors\": null, \"strict_validation\": null, \"allow_new_fields\": null}, \"vault_id\": 2454}"
    ),
    date = structure(1685368215, class = c("POSIXct", "POSIXt"), tzone = "GMT"),
    times = c(
      redirect = 0,
      namelookup = 2.1e-05,
      connect = 2.2e-05,
      pretransfer = 8.3e-05,
      starttransfer = 9.5e-05,
      total = 0.238604
    )
  ),
  class = "response"
)
