structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Thu, 13 Apr 2023 15:49:57 GMT",
    `content-type` = "application/json", `content-length` = "1661",
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
      date = "Thu, 13 Apr 2023 15:49:57 GMT",
      `content-type` = "application/json", `content-length` = "1661",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [\"2021188097437023585\", \"2021188099322456096\"], \"availability\": \"unverified\", \"class_name\": \"Object\", \"created_at\": \"2023-04-13T15:49:57.559Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 2, \"description\": null, \"filename\": \"toto.txt\", \"full_path\": \"vsim-dev:quartzbio.edp.test.objects:/dir1/dir2/toto.txt\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2021188100964818649\", \"is_deleted\": false, \"is_transformable\": true, \"last_accessed\": \"2023-04-13T15:49:57.559Z\", \"last_modified\": \"2023-04-13T15:49:57.559Z\", \"md5\": null, \"metadata\": {}, \"mimetype\": \"text/plain\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"file\", \"parent_object_id\": \"2021188099322456096\", \"path\": \"/dir1/dir2/toto.txt\", \"size\": null, \"tags\": [], \"updated_at\": \"2023-04-13T15:49:57.605Z\", \"upload_url\": \"https://qb-edp-dev.s3.amazonaws.com/uploads/3/2021188101085154365?AWSAccessKeyId=ASIAUY4D3D27FVOGOO44&x-amz-acl=private&Expires=1681487397&x-amz-security-token=IQoJb3JpZ2luX2VjEO3%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQD8fcXW5JdM4axycAUR5g66r6TV6XEEP9nUrmXQ6gZ5agIhAKhvlbadnKEH%2F7A0cPnd3wiaPosTbEEscLyCJzLamTCbKoYECNb%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQAxoMMzI4MzA0NjMxNDg2IgxApB3gxV1LtIMilxkq2gPyutla7mnga4HILabsCX3R1wGPd5R%2Fewr5g5h5vkmUXrNUGEL1Xj43bccS4o7Ix8i2yh81HD8VVJbsvxwrlWepePy4XOCVNXLfoNITFHA6t7MCAdt5yVp4%2B6IHN9IG5sqbcHZ%2F0dXGV5JgJYfk%2BGkXdv1v7lsPHMyLB5TcC7lUHyle8yg83%2FPPxBLISe79dAiARTMtjDrzVwO19gf2wO2tNXE8ZU0fAcLUw6U1HVnUpwtuYd%2B6IYiB2DbgfBL%2B4Sxb9ThzPBQBOiJtSQrLvdOtUMxESzBB42MXAAyNPP%2BuC4dO3YVCgvVZJ2j4laJHONBcLLMURwg4ZCS2c4YMdXJYv7vWK%2FafCAPR4t5hUz3hetZ%2FLqakxPkITFtU2uIPFd2KkQHWSlGScwZVxDFGpqhkC9H%2ByTPVb9akYZErm5WZmDBW19yV2tJfvNKmU5TfXU4PNN7RZfnuqrRSZ89m78dLAtKLXXAxc9%2BqB3%2BBgSbKROH1%2FD8k5vFZ2KrWQChgGEhaX%2Fjgldi6ip7D%2B20DH8yZUrm9OLMcGdC5CkHwoU%2Fb5hvVK9iKx%2F4w0gWBYYDAwhJTfY%2FAXzJ89KjJIWJWykU4pfdTuzAzWdsZpVg70rzEPE431Gzk4pvdDFMwwejfoQY6pAFEOaxv61A9J8Sp%2B3w1YvEy%2BrntsFEvaphOZnl3YzYzmvlicm9w4GOd5ho5z5ot4lUQTRtE1gPsAR51smpebOOrnTmVTSimp7%2BP1wP5k3j55xiOnuMIzWIrSAsJ4gJhf4med4HhYcphQ8KVFqDQhhtF3OSL6qkQKlHNsLP6EveJpSHzAfeJTmxSZr%2BG%2B6J9jLYaZ4TrdEWZV8jjMRCDiaC4diILjg%3D%3D&Signature=9zXNV7tVlXu5dXDoQsC5kXLVOlo%3D&x-amz-server-side-encryption=AES256\", \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 51, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 51, \"vault_id\": 1940, \"vault_name\": \"quartzbio.edp.test.objects\", \"global_beacon\": null}"),
  date = structure(1681400997, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.6e-05,
    connect = 3.9e-05, pretransfer = 0.00013, starttransfer = 0.000135,
    total = 0.189698
  )
), class = "response")
