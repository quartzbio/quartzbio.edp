#' fetches a list of files.
#' @inheritParams params
#' @inheritDotParams Objects
#' @export
Files <- function(...) {
  Objects(..., object_type = "file")
}

#' fetches a file by id, full_path or (vault_id, path)
#' @param id    a File ID
#' @inheritParams params
#' @return the file info as an Object
#' @export
File <- function(
    id = NULL, full_path = NULL, path = NULL, vault_id = NULL,
    conn = get_connection()) {
  Object(
    object_type = "file", id = id, full_path = full_path, path = path, vault_id = vault_id,
    conn = conn
  )
}


#' uploads a file
#' Upload a file to a QuartzBio vault.
#' Automatically uses multipart upload for files larger than the multipart_threshold.
#' multipart_threshold (int): File size threshold for multipart upload (default: 64MB)
#' multipart_chunksize (int): Size of each upload part (default: 64MB)
#' @inheritParams params
#' @importFrom mime guess_type
#' @export
File_upload <- function(
    vault_id, local_path, vault_path,
    mimetype = mime::guess_type(local_path),
    conn = get_connection()) {
  vault_id <- id(vault_id)
  .die_unless(file.exists(local_path), 'bad local_path "%s"', local_path)
  size <- file.size(local_path)
  # Get MD5 and check if multipart upload is needed
  multipart_threshold <- 64 * 1024 * 1024

  force(mimetype)
  md5 <- tools::md5sum(local_path)[[1]]


  obj <- File_create(vault_id, vault_path,
    size = size,
    mimetype = mimetype,
    md5 = md5,
    conn = conn
  )

  # Check if multipart upload is needed
  if (obj$is_multipart) {
    res <- try(Multi_part_file_upload(
      obj = obj,
      local_path = local_path,
      local_md5 = md5
    ))
  } else {
    res <- try(File_upload_content(obj$upload_url, local_path, size = size, mimetype = mimetype, md5 = md5))
    if (.is_error(res) || res$status != 200) {
      warning("deleting object file because uploading file content failed...")
      del <- try(delete(obj, conn = conn), silent = TRUE)
      if (.is_error(del)) {
        message("could not delete the Object ", obj$id, " : ", .get_error_msg(del))
      }

      err <- get_api_response_error_message(res)
      if (is.null(err) || length(err) == 0) err <- "Error in parsing error message"
      .die("uploading file content failed with code %s: %s", res$status, err)
    }
  }

  obj
}

File_create <- function(vault_id, vault_path, object_type = "file", conn = get_connection(), ...) {
  vault_id <- id(vault_id)
  vault_path <- path_make_absolute(vault_path)
  filename <- basename(vault_path)
  .die_unless(.is_nz_string(filename), 'bad vault_path "%s"', vault_path)

  parent_path <- dirname(vault_path)
  fo <- Folder_fetch_or_create(vault_id, parent_path, conn = conn)

  Object_create(vault_id, filename,
    object_type = object_type,
    parent_object_id = fo$id,
    conn = conn,
    ...
  )
}


File_upload_content <- function(upload_url, path, size, mimetype, md5 = tools::md5sum(path)[[1]]) {
  message("uploading file ", path, "...")

  encoded_md5 <- jsonlite::base64_enc(hex2raw(md5))
  headers <- c("Content-MD5" = encoded_md5, "Content-Type" = mimetype, "Content-Length" = size)

  PUT(upload_url, add_headers(headers), body = upload_file(path, type = mimetype))
}

#' Function to support multi-part upload for files larger than multipart_threshold.
#'
#' @param obj Object created
#' @param local_path Path of file in local
#' @param local_md5 md5sum checksum of file
#' @param conn Valid EDP connection
#' @inheritDotParams Objects
Multi_part_file_upload <- function(obj, local_path, local_md5, conn = get_connection(), ...) {
  # Fetching upload ID
  client <- NULL
  if (is.null(client)) {
    client <- obj$client
  }

  cat("Notice: Upload ID", obj$upload_id, "\n")

  # Get presigned urls

  presigned_urls <- obj$presigned_urls
  cat("Notice: Starting multipart upload with", length(presigned_urls), "parts...\n")

  parts <- list()
  file_conn <- file(local_path, "rb")
  for (part_info in presigned_urls) {
    part_number <- part_info$part_number
    start_byte <- part_info$start_byte
    end_byte <- part_info$end_byte
    part_size <- part_info$size
    upload_url <- part_info$upload_url

    cat(sprintf(
      "Notice: Uploading part %s/%s... (bytes %s-%s)\n",
      as.numeric(part_number), length(presigned_urls), as.numeric(start_byte), as.numeric(end_byte)
    ))

    seek(file_conn, where = start_byte, origin = "start")
    chunk_data <- readBin(file_conn, what = "raw", n = part_size)

    if (length(chunk_data) == 0) {
      break
    }

    # Retry logic
    success <- FALSE
    retries <- 3
    for (i in 1:retries) {
      resp <- PUT(upload_url,
        body = chunk_data,
        add_headers(`Content-Length` = length(chunk_data)),
        encode = "raw"
      )

      if (httr::status_code(resp) == 200) {
        success <- TRUE
        break
      } else {
        Sys.sleep(2^i)
      }
    }

    if (!success) {
      stop(sprintf("Failed to upload part %d: %s", part_number, content(resp, "text")))
    }
    etag <- gsub('"', "", httr::headers(resp)[["etag"]])
    parts[[length(parts) + 1]] <- list(part_number = part_number, etag = etag)
  }
  close(file_conn)

  cat("Notice: Completing multipart upload....\n")
  complete_data <- list(
    upload_id = obj$upload_id,
    physical_object_id = obj$upload_key,
    parts = parts
  )

  cat("Notice:", jsonlite::toJSON(complete_data, auto_unbox = TRUE), "\n")

  complete_resp <- request_edp_api("POST", "v2/complete_multi_part", conn = conn, params = complete_data)

  if ("message" %in% names(complete_resp)) {
    cat(sprintf(
      "Notice: Successfully uploaded %s to %s with multipart upload.\n",
      local_path, obj$path
    ))
    return(obj)
  } else {
    stop("Multipart upload failed: ", content(complete_resp, "text"))
  }
}

#' queries the content of a file.
#'
#' The file has to be parsable by EDP. Otherwise you can use [File_download()]
#'
#' @param id    a File ID
#' @inheritParams params
#' @export
File_query <- function(
    id, filters = NULL, limit = 10000, offset = NULL, all = FALSE,
    conn = get_connection()) {
  id <- id(id)
  params <- list()

  # filters: may be a JSON string or a R data structure
  if (.is_nz_string(filters)) {
    filters <- jsonlite::fromJSON(filters, simplifyVector = FALSE)
  }


  total <- NULL
  if (.empty(filters)) {
    # cf https://precisionformedicine.atlassian.net/browse/SBP-527
    # no filters --> use File documents_count
    msg("fetching the number of rows of the file...")

    fi <- File(id, conn = conn)
    total <- fi$documents_count
    msg("found %s lines", total)
  } else {
    params$filters <- filters
  }

  df <- request_edp_api("POST", file.path("v2/objects", id, "data"),
    params = params,
    parse_as_df = TRUE, conn = conn, limit = limit, offset = offset, total = total
  )
  if (all) df <- fetch_all(df)

  df
}

#' fetches the download URL of a file.
#'
#' This URL can then be used to download the file using any HTTP client, such as
#' utils::download.file()
#' @inheritParams params
#' @return the download URL as a string
#' @export
File_get_download_url <- function(file_id, conn = get_connection()) {
  request_edp_api("GET", file.path("v2/objects", id(file_id), "download"),
    postprocess = FALSE,
    conn = conn
  )$download_url
}

#' utility function that downloads an EDP File into a local file
#'
#' @inheritParams params
#' @param ...  passed to File_download_content()
#' @return the response
#' @export
File_download <- function(file_id, local_path, conn = get_connection(), ...) {
  url <- File_get_download_url(file_id, conn = conn)
  File_download_content(url, local_path, ...)
}

File_download_content <- function(url, local_path, overwrite = FALSE, ...) {
  httr::GET(url, httr::write_disk(local_path, overwrite = overwrite), ...)
}

#' convenience function to download a file into memory, just a wrapper over File_download()
#'
#' @inheritParams params
#' @param local_path  where to download the file. Used for testing purposes.
#' @param ...  passed to File_download()
#' @return the file content
#' @export
File_read <- function(file_id, local_path = tempfile(), conn = get_connection(), ...) {
  if (missing(local_path)) {
    on.exit(unlink(local_path), add = TRUE)
  }
  File_download(file_id, local_path, conn = conn, ...)

  readLines(local_path)
}
