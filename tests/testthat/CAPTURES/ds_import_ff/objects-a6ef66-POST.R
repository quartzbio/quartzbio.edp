structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Tue, 26 Sep 2023 10:06:21 GMT",
    `content-type` = "application/json", `content-length` = "1739",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
    server = "nginx", `content-encoding` = "gzip", `strict-transport-security` = "max-age=31536000; includeSubDomains",
    vary = "Authorization, Origin, Accept-Encoding", `solvebio-version` = "4.2.1-qb-dev",
    allow = "GET, POST, HEAD, OPTIONS", `x-frame-options` = "SAMEORIGIN"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 201L, version = "HTTP/2",
    headers = structure(list(
      date = "Tue, 26 Sep 2023 10:06:21 GMT",
      `content-type` = "application/json", `content-length` = "1739",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
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
  content = charToRaw("{\"account_id\": 3, \"ancestor_object_ids\": [\"2141327927207561065\", \"2141327929252201278\", \"2141327931196310262\"], \"availability\": \"unverified\", \"class_name\": \"Object\", \"created_at\": \"2023-09-26T10:06:21.542Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 3, \"description\": null, \"filename\": \"mtcars.csv\", \"full_path\": \"vsim-dev:quartzbio.edp.test.ds_import_ff:/a/b/c/mtcars.csv\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"2141327932658290318\", \"is_deleted\": false, \"is_transformable\": true, \"last_accessed\": \"2023-09-26T10:06:21.542Z\", \"last_modified\": \"2023-09-26T10:06:21.542Z\", \"md5\": \"9a02503f1dfdcb9057a74de2c2034e26\", \"metadata\": {}, \"mimetype\": \"text/csv\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"file\", \"parent_object_id\": \"2141327931196310262\", \"path\": \"/a/b/c/mtcars.csv\", \"size\": 225, \"tags\": [], \"updated_at\": \"2023-09-26T10:06:21.593Z\", \"upload_url\": \"https://qb-edp-dev.s3.amazonaws.com/uploads/3/2141327932794809794?AWSAccessKeyId=ASIAUY4D3D27P3WLJKZ4&x-amz-acl=private&Expires=1695809181&content-md5=mgJQPx39y5BXp03iwgNOJg%3D%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEHoaCXVzLWVhc3QtMSJHMEUCIG7Jx8pPdrx2G6uAFBYlQbetUpLibMrA%2BEa2NXIR491nAiEA8dxfKyVXF5knODWvd2e7%2FoatoL7GPzElZJtl6BFdnuAq%2FQMIcxADGgwzMjgzMDQ2MzE0ODYiDFna2wInVIPCMTGd%2FSraA59UhTNKdLjYzHP7vWJ9o19yyLN9WCdKBRbiJMY9xxlVcd57Yj0pADbCKr2uTBTUYpJg92bMiMVVczYvnLfBtyJTCk%2BiuREZ5UGd%2B1fEsvpO0j0sWihMnknetSxkYXwZfUEcY2PSr9B7lNTyzW9%2BHudQqZEjN%2F5kimbaQJpEx5lH54LS%2Fvl1aNB4sRckWOs1mVIftomWl1mVMed9RVB%2BP5TqWN1LCpoi2QyZH4safxwQSRWCgH3xY2H9HiUFM6roXyv8y%2Fjuk3LuqO5VFW21QjENEaQSwdcLbvx7IO20BnuEtY7xPDuNnU%2FtvwkIhUcdtJLuNHcHoAk4H86pm9Swmli3YL9tGs3SP870u%2BitN%2B45HpThaA%2BI4gzdy%2FpVeOUTigq4IUyYneaIisNcqgjGDbNk2tpzhyu6%2BNlFqvCVEseWzVhXeWgVYwlMOn%2BwdKP6xkjkPe99WBmZvuG83FWmTaf9kXxyZyivB74%2BdI5mabag3PHlKJne4wGVzDfOSiFDV0Q5p6ZuuxBzwVj61QcRNDNFgtB0ZONU5IzXxrUNnBpgUzcJRZuOag7Qv%2BUdv85SazCDt3AkkpJfrVr3Pt6qyZ1EDMZTozYduYlE7IlkxK8TNWvEKcyZPqJYzDCDyMqoBjqlAd4Im%2BFGBBhzAw7UMG3RXhfsmaI1loYixZ2of9OiQBhDnXU8ZrUj4qZHZNcdQMwV3LmpKVa%2FRl%2Fs%2FKku4ZGhqq2J2uXqaZ3tKwp67AXbVDhDy6DWGFzKB%2FxkVEIB5%2BJ2Le5AT8OW3%2B9bw6IZJ0TQgDkds0kXBlnJbxmxrj%2B78kQPJls2%2FEMCDHAgDCp5fecbs2HkCbgGlVVwY9t2jcQlZ3xR36erzg%3D%3D&Signature=WYxrrIbp86kLZCuk0S0Qo%2F3XJEE%3D&x-amz-server-side-encryption=AES256&content-type=text%2Fcsv\", \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Marc\", \"full_name\": \"Marc Lamarine\", \"id\": 71, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 71, \"vault_id\": 3316, \"vault_name\": \"quartzbio.edp.test.ds_import_ff\", \"version_count\": 1, \"global_beacon\": null}"),
  date = structure(1695722781, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 2.2e-05,
    connect = 2.4e-05, pretransfer = 9.7e-05, starttransfer = 1e-04,
    total = 0.193077
  )
), class = "response")
