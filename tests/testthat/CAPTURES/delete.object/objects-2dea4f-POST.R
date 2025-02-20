structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Thu, 13 Apr 2023 15:49:55 GMT",
    `content-type` = "application/json", `content-length` = "1651",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "3.62.0-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Thu, 13 Apr 2023 15:49:55 GMT",
      `content-type` = "application/json", `content-length` = "1651",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
      server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [\"2021188078461140521\"], \"availability\": \"unverified\", \"class_name\": \"Object\", \"created_at\": \"2023-04-13T15:49:55.542Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 1, \"description\": null, \"filename\": \"toto.txt\", \"full_path\": \"vsim-dev:quartzbio.edp.test.delete.object:/dir1/toto.txt\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2021188084057508830\", \"is_deleted\": false, \"is_transformable\": true, \"last_accessed\": \"2023-04-13T15:49:55.542Z\", \"last_modified\": \"2023-04-13T15:49:55.542Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"text/plain\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"file\", \"parent_object_id\": \"2021188078461140521\", \"path\": \"/dir1/toto.txt\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-04-13T15:49:55.601Z\", \"upload_url\": \"https://qb-edp-dev.s3.amazonaws.com/uploads/3/2021188084216158684?AWSAccessKeyId=ASIAUY4D3D27G4QRQJTC&x-amz-acl=private&Expires=1681487395&x-amz-security-token=IQoJb3JpZ2luX2VjEO%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIHakJss7acqKddfgWWAVEwmsLO0fVUU4K%2BH2L8wbatqHAiEA1WaPpthQyke5EXhXgTVk4wieeQCcQp9I64xTHSNK0OkqhgQI1%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARADGgwzMjgzMDQ2MzE0ODYiDEIxi0N4K1oA6gZpIiraA8PRa3Nmh66prCgbq4Zm%2Bqbk%2BlI6q3Ug6yAYFEXALaBhFGqzJpcjOgS%2FWf%2FwmKqMRLBOiNCAuXKo3%2FeVafhHEpFbAQ3lYlJHAoF7TGNV7%2B5iupp4UKEH6ok8cHHbSobCVxrKE6fPS%2Biu7t2AHMNAlzMHQaauc7%2BsGmr8r%2F9Q7xlowJlcCCMV9USlqI%2FT%2Fi8PhHLt5uT5EvlV8iSRaFj86ph2SXPe6LKHHfJAXf23EjdELhrJn0OAsCjDhghK%2FFfcJn4Jcs1yCN%2Fh6lR8EFHt49jz13PdUV%2BD2CJ86luOY4%2FxT2U0KbgZSJJkl9uW%2BxALZIbTyr2h9QMZyKHwsFbnWUPHqIdQ5RgJQqp1GcivpMeoUILtiOiZwfifd6du%2FZcg9QqKFwyUfwwy7TEwvRBANQ61wXAXxIllfFwRZl9oiM6WizpkuYebw%2FPpckG4d0n805mv%2FFvWL8eZH7f%2FthBxMEHYiwsR9X9nH4K6Xv0pPdc2NDUYdmDATZBNC35rAI9MEL01zAZF3WP%2B8GuOlsNzLNRwDl06OC%2BU2uakBbQu9B65wV4EftCBtLEaGHyZZVlG%2BwPstDWxvRNdJXk%2Bqu0wks%2FFbQN%2FAZ6N9u9Nr6TeftrujLGlmlCEYhs0EDCDnuChBjqlASUsS6U67%2FWTn0m%2BmjXl2pzqmteXT13Dv3EOykztAs25G57Vpx5sjGGyeD9mnYuMLBL2dOEumD%2BXjQYsM6zriBjFoSh264ewor4N97qlhh0GiWJcGbksYse%2FBASgTgqPc2H5UO1o2f%2FAi%2B7FyfJK3fMNKMVFj%2FAkOQeH2KpYW7W8q7bdBYKeIarOAH9ryhn3Fr4BOqeMawPJScoISLyGnCv1ACce8Q%3D%3D&Signature=yf7tkAp3N1RghbhyjWUZzpyQTCI%3D&x-amz-server-side-encryption=AES256\", \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 1939, \"vault_name\": \"quartzbio.edp.test.delete.object\", \"global_beacon\": null}"),
  date = structure(1681400995, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 7.1e-05,
    connect = 7.5e-05, pretransfer = 0.000232, starttransfer = 0.000242,
    total = 0.213785
  )
), class = "response")
