structure(list(
  url = "https://vsim-dev.api.edp.aws.quartz.bio/v2/objects",
  status_code = 201L, headers = structure(list(
    date = "Fri, 27 Jan 2023 15:02:22 GMT",
    `content-type` = "application/json", `content-length` = "1700",
    location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
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
      date = "Fri, 27 Jan 2023 15:02:22 GMT",
      `content-type` = "application/json", `content-length` = "1700",
      location = "https://vsim-dev.api.edp.aws.quartz.bio/v2/None",
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
  content = charToRaw("{\"account_id\": 7, \"ancestor_object_ids\": [], \"availability\": \"unverified\", \"class_name\": \"Object\", \"created_at\": \"2023-01-27T15:02:22.620Z\", \"dataset_description\": null, \"dataset_documents_count\": null, \"documents_count\": null, \"dataset_full_name\": null, \"storage_class\": null, \"dataset_id\": null, \"depth\": 0, \"description\": null, \"filename\": \"toto.json\", \"full_path\": \"sandbox:quartzbio.edp.test.fup_error:/toto.json\", \"has_children\": false, \"has_folder_children\": false, \"id\": \"1966081196452564655\", \"is_deleted\": false, \"is_transformable\": true, \"last_accessed\": \"2023-01-27T15:02:22.620Z\", \"last_modified\": \"2023-01-27T15:02:22.620Z\", \"md5\": \"3abeb0926a1e11f8aaf4a94c9d4fedf1\", \"metadata\": {}, \"mimetype\": \"application/json\", \"num_children\": 0, \"num_descendants\": 0, \"object_type\": \"file\", \"parent_object_id\": null, \"path\": \"/toto.json\", \"size\": 79, \"tags\": [], \"updated_at\": \"2023-01-27T15:02:22.697Z\", \"upload_url\": \"https://qb-edp-dev.s3.amazonaws.com/uploads/7/1966081196617819266?AWSAccessKeyId=ASIAUY4D3D27DMMJRCVV&x-amz-acl=private&Expires=1674918142&content-md5=Or6wkmoeEfiq9KlMnU%2Ft8Q%3D%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEM7%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQC4c9rpuT8uEyYgMmYidaR6iBClGEtCJgjd%2F23KlwKonAIhAP5RamVYlYa9BxVRAcZkL1Z%2Fmm6aNV4llCjvOGUAbWbOKv0DCEcQAxoMMzI4MzA0NjMxNDg2IgyVwiOqAckSdW6Qymsq2gMkPnI6%2FF46pyQj24JtsdsKoDppne%2BPy8bh3raOPZUqYyMTd%2FUMm89BohwBd3JjbZoXDm9prWkqtLfTZ2Iq2VnAi81SEcNs7HLyeQhwbCGHJO0enqaV19ccq15Rrkfyp3RfKDu17nQ%2BEPVGP%2BYW5iNyuYieFfarGC9EfWPdxvnhf2K4TckeoEEwviU8kvvNaELznWQ5YnB0f2H1GSV%2FDqbe0Z4lPHl%2FtsnkYVlhFQ5paiM9xok2HjDqC9kMuX43P4k29xBuYh%2FTfsay4SJ7O%2F3a6yA87xXrZfVpTmMcGCpm9JXjwtx4zApCy%2F7Ii3BRV%2B1wh%2F7zF%2Bu7K9FC49lcLT%2FfOIB603gqhCVOfHD0NcU0veOR2CXXonzQEECv1AZq%2F0nqSJOBxuZXdex%2FplQCxpagW6D6aFAWvT1o7fwF%2BF1Ib3yOSF88lRVybxG45V6vbuqq5HsHQ%2FOV7CzfkThkMVnk8FPC2S%2BkSI0Yy5r5ANu81S2tamc8m76KOUCBoosV6tfS%2Foptj3eTfBKR7xwI0I5pQwsVlVMY5ZztdiYNEYJHDpkMAuvjS2kGgk%2FGYNp0%2FXmXpJ7D7q1sD92nC%2BAAaBIr2jQCtsfbD5R68%2FzGqdFKkZO2ldHwlmP%2FNRww1qHPngY6pAGUZ3FeA7B%2BwBJr%2BMZEGfmWxAIAQ5NjydzvCig2RwtatW9XqHLEZiWHiELLzNufOmd5D%2FgNrYSV0hc4U7TUS1WHlYoh%2FGjEhdFQHT4OICsQxk1rJf7WV%2FWbf8i2RRCPqB3Wq%2Bv8lM6%2BF%2FzvlArH8pZWiRVEk9gtKOFGctjwNqDOsOqRwl4aAAgYCl96gMeb7yrXBR4iyC8xx9OJN2lKNJVWEn9TQA%3D%3D&Signature=Xc9VWDuYb6PArKYqhNAvx2pT2nA%3D&x-amz-server-side-encryption=AES256&content-type=application%2Fjson\", \"url\": null, \"user\": {\"class_name\": \"User\", \"email\": \"Test.User@fakemail.com\", \"first_name\": \"Test\", \"full_name\": \"Test User\", \"id\": 32, \"is_active\": true, \"is_staff\": false, \"role\": \"member\", \"title\": \"\"}, \"user_id\": 32, \"vault_id\": 1109, \"vault_name\": \"quartzbio.edp.test.fup_error\", \"global_beacon\": null}"),
  date = structure(1674831742, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.4e-05,
    connect = 3.6e-05, pretransfer = 0.000126, starttransfer = 0.000131,
    total = 0.230098
  )
), class = "response")
