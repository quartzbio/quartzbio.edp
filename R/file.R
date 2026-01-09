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
  id = NULL,
  full_path = NULL,
  path = NULL,
  vault_id = NULL,
  conn = get_connection()
) {
  Object(
    object_type = "file",
    id = id,
    full_path = full_path,
    path = path,
    vault_id = vault_id,
    conn = conn
  )
}


#' uploads a file
#' Upload a file to a QuartzBio vault.
#' Automatically uses multipart upload for files larger than the multipart_threshold.
#' multipart_threshold (int): File size threshold for multipart upload (default: 64MB)
#' multipart_chunksize (int): Size of each upload part (default: 64MB)
#' @param max_retries Maximum retries per part for multipart upload (default: 3)
#' @param num_processes Number of parallel workers for multipart upload (default: 1)
#' @inheritParams params
#' @importFrom mime guess_type
#' @export
File_upload <- function(
  vault_id,
  local_path,
  vault_path,
  mimetype = mime::guess_type(local_path),
  max_retries = 3,
  num_processes = 1,
  conn = get_connection()
) {
  vault_id <- id(vault_id)
  .die_unless(file.exists(local_path), 'bad local_path "%s"', local_path)
  size <- file.size(local_path)
  # Get MD5 and check if multipart upload is needed
  multipart_threshold <- 64 * 1024 * 1024

  force(mimetype)
  md5 <- tools::md5sum(local_path)[[1]]

  obj <- File_create(
    vault_id,
    vault_path,
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
      local_md5 = md5,
      num_processes = num_processes,
      max_retries = max_retries
    ))
  } else {
    res <- try(File_upload_content(
      obj$upload_url,
      local_path,
      size = size,
      mimetype = mimetype,
      md5 = md5
    ))
    if (.is_error(res) || res$status != 200) {
      warning("deleting object file because uploading file content failed...")
      del <- try(delete(obj, conn = conn), silent = TRUE)
      if (.is_error(del)) {
        message(
          "could not delete the Object ",
          obj$id,
          " : ",
          .get_error_msg(del)
        )
      }

      err <- get_api_response_error_message(res)
      if (is.null(err) || length(err) == 0) {
        err <- "Error in parsing error message"
      }
      .die("uploading file content failed with code %s: %s", res$status, err)
    }
  }

  obj
}

File_create <- function(
  vault_id,
  vault_path,
  object_type = "file",
  conn = get_connection(),
  ...
) {
  vault_id <- id(vault_id)
  vault_path <- path_make_absolute(vault_path)
  filename <- basename(vault_path)
  .die_unless(.is_nz_string(filename), 'bad vault_path "%s"', vault_path)

  parent_path <- dirname(vault_path)
  fo <- Folder_fetch_or_create(vault_id, parent_path, conn = conn)

  Object_create(
    vault_id,
    filename,
    object_type = object_type,
    parent_object_id = fo$id,
    conn = conn,
    ...
  )
}


File_upload_content <- function(
  upload_url,
  path,
  size,
  mimetype,
  md5 = tools::md5sum(path)[[1]]
) {
  message("uploading file ", path, "...")

  encoded_md5 <- jsonlite::base64_enc(hex2raw(md5))
  headers <- c(
    "Content-MD5" = encoded_md5,
    "Content-Type" = mimetype,
    "Content-Length" = size
  )

  PUT(
    upload_url,
    add_headers(headers),
    body = upload_file(path, type = mimetype)
  )
}

#' Refresh presigned URLs for multipart upload
#' @param upload_id description
#' @param key description
#' @param size description
#' @param part_numbers description
#' @param conn Valid EDP connection
#' @import httr
#' @inheritDotParams Objects
#' @export
refresh_presigned_urls <- function(
  upload_id,
  key,
  size,
  part_numbers,
  conn = get_connection(),
  ...
) {
  payload <- list(
    upload_id = upload_id,
    key = key,
    total_size = size,
    part_numbers = part_numbers
  )

  tryCatch(
    {
      response <- request_edp_api(
        "POST",
        "v2/presigned_urls",
        conn = conn,
        params = payload
      )

      if (!is.null(response$presigned_urls)) {
        return(response["presigned_urls"])
      } else {
        stop(
          "Invalid response from presigned URLs API: missing 'presigned_urls' key"
        )
      }
    },
    error = function(e) {
      .die("Failed to refresh presigned URLs: ", e$message)
    }
  )
}

#' Function to Upload a single part with retry logic and presigned URL refresh
#' @param local_path Path of file in local
#' @param task task with file parts to be uploaded
#' @param object File object created
#' @param file_handle file handle for sequential upload
#' @param conn Valid EDP connection
#' @import httr
#' @inheritDotParams Objects
#' @export
upload_single_part <- function(
  local_path,
  task,
  object,
  file_handle = NULL,
  conn = get_connection(),
  ...
) {
  part_number <- task$part_number
  start_byte <- task$start_byte
  part_size <- task$part_size
  max_retries <- task$max_retries
  upload_id <- task$upload_id
  upload_key <- task$upload_key
  worker_id <- if (!is.null(task$worker_id)) {
    task$worker_id
  } else {
    "Sequential worker"
  }

  for (attempt in seq_len(max_retries)) {
    tryCatch(
      {
        # Refresh presigned URL if retrying
        if (attempt > 1) {
          message(sprintf(
            "%s retrying part %s (attempt %d/%d)",
            worker_id,
            part_number,
            attempt,
            max_retries
          ))

          fresh_urls <- refresh_presigned_urls(
            upload_id = upload_id,
            key = upload_key,
            size = object$size,
            part_numbers = list(part_number),
            ...
          )
          upload_url <- fresh_urls[[1]]$upload_url
        } else {
          upload_url <- task$upload_url
        }

        # Read part data
        if (!is.null(file_handle)) {
          seek(file_handle, where = start_byte, origin = "start")
          chunk_data <- readBin(file_handle, what = "raw", n = part_size)
        } else {
          con <- file(local_path, "rb")
          seek(con, where = start_byte, origin = "start")
          chunk_data <- readBin(con, what = "raw", n = part_size)
          close(con)
        }

        if (length(chunk_data) == 0) {
          break
        }

        # Calculate timeout
        part_size_mb <- length(chunk_data) / (1024 * 1024)
        # Timeout scaling for large parts (5MB to 1GB+)
        # Formula: 3min base + 10s per MB
        base_timeout <- 180
        scaling_factor <- 10
        read_timeout <- base_timeout + part_size_mb * scaling_factor
        connect_timeout <- 30
        # Upload part
        resp <- httr::PUT(
          url = upload_url,
          body = chunk_data,
          httr::add_headers(
            `Content-Length` = as.character(length(chunk_data))
          ),
          httr::timeout(connect_timeout + read_timeout)
        )

        if (httr::status_code(resp) == 200) {
          etag <- gsub('"', "", httr::headers(resp)[["etag"]])
          return(list(part_number = part_number, etag = etag))
        } else {
          stop(sprintf(
            "%s failed part %d: %d - %s",
            worker_id,
            part_number,
            httr::status_code(resp),
            httr::content(resp, "text")
          ))
        }
      },
      error = function(e) {
        if (attempt == max_retries) {
          stop(sprintf(
            "%s part %d failed after %d attempts: %s",
            worker_id,
            part_number,
            max_retries,
            e$message
          ))
        }

        wait_time <- 2^(attempt - 1)
        message(sprintf(
          "%s part %d failed (attempt %d/%d): %s, retrying in %ds...",
          worker_id,
          part_number,
          attempt,
          max_retries,
          e$message,
          wait_time
        ))
        Sys.sleep(wait_time)
      }
    )
  }
}

#' Function to upload parts in parallel using future multisession
#' @param local_path Path of file in local
#' @param part_tasks File parts to be uploaded
#' @param object File object created
#' @param parts vector list of part tasks
#' @param num_processes Number of parallel workers for multipart upload
#' @param conn Valid EDP connection
#' @inheritDotParams Objects
#' @export
upload_parts_with_multisession <- function(
  local_path,
  part_tasks,
  object,
  parts,
  num_processes,
  conn = get_connection(),
  ...
) {
  future::plan(future::multisession, workers = num_processes)
  failed_parts <- list()
  pkgname <- asNamespace("quartzbio.edp")
  upload_single_part <- get("upload_single_part", envir = pkgname)
  refresh_presigned_urls <- get("refresh_presigned_urls", envir = pkgname)

  if (isNamespaceLoaded("quartzbio.edp")) {
    future_packages <- "quartzbio.edp"
  }
  results <- future.apply::future_lapply(
    seq_along(part_tasks),
    function(i) {
      task <- part_tasks[[i]]
      task$worker_id <- paste0("Worker-", (i %% num_processes) + 1)

      tryCatch(
        {
          part_result <- upload_single_part(
            local_path = local_path,
            task = task,
            object = object
          )
          return(list(
            index = task$part_index,
            result = part_result,
            task = task
          ))
        },
        error = function(e) {
          message(sprintf(
            "ERROR: %s failed part %s: %s",
            task$worker_id,
            task$part_number,
            e$message
          ))
          # return failed task NULL
          NULL
        }
      )
    },
    future.seed = NULL,
    future.packages = future_packages
  )

  # Create parts from results
  for (res in results) {
    if (!is.null(res)) {
      parts[[res$index]] <- res$result
    }
  }

  # Filter out failed uploads
  #failed_parts <- Filter(is.null, results)
  list(
    failed_parts = Filter(is.null, results),
    updated_parts = parts
  )
}

#' Function to upload parts in parallel
#' @param local_path Path of file in local
#' @param part_tasks File parts to be uploaded
#' @param object File object created
#' @param num_processes Number of parallel workers for multipart upload
#' @param conn Valid EDP connection
#' @inheritDotParams Objects
upload_parts_parallel <- function(
  local_path,
  part_tasks,
  object,
  num_processes,
  conn = get_connection(),
  ...
) {
  parts <- vector("list", length(part_tasks))

  # Upload parts in parallel
  upload_result <- upload_parts_with_multisession(
    local_path,
    part_tasks,
    object,
    parts,
    num_processes
  )

  failed_parts <- upload_result$failed_parts
  parts <- upload_result$updated_parts

  # Retry upload for failed parts
  if (length(failed_parts) > 0) {
    message(sprintf(
      "Retrying %d failed parts in parallel...",
      length(failed_parts)
    ))
    for (i in seq_along(failed_parts)) {
      failed_parts[[i]]$max_retries <- 3
    }

    retry_result <- upload_parts_with_multisession(
      local_path,
      failed_parts,
      object,
      parts,
      num_processes
    )

    retry_failed <- retry_result$failed_parts
    parts <- retry_result$updated_parts

    if (length(retry_failed) > 0) {
      stop(sprintf(
        "Failed to upload %d parts after retry",
        length(retry_failed)
      ))
    }
  }

  # Return successfully uploaded parts
  #return(Filter(Negate(is.null), parts))
  parts
}

#' Upload parts sequentially with retry logic for failed parts
#' @param local_path Path of file in local
#' @param part_tasks File object created
#' @param object File object created
#' @param conn Valid EDP connection
#' @inheritDotParams Objects
upload_parts_sequential <- function(
  local_path,
  part_tasks,
  object,
  conn = get_connection(),
  ...
) {
  parts <- vector("list", length(part_tasks))
  failed_parts <- list()

  file_handle <- file(local_path, "rb")
  on.exit(close(file_handle))

  for (i in seq_along(part_tasks)) {
    task <- part_tasks[[i]]
    tryCatch(
      {
        part_result <- upload_single_part(
          local_path,
          task,
          object,
          file_handle = file_handle
        )
        parts[[i]] <- part_result
      },
      error = function(e) {
        message(sprintf(
          "ERROR: Sequential worker failed part %s: %s",
          task$part_number,
          e$message
        ))
        failed_parts[[length(failed_parts) + 1]] <<- task
      }
    )
  }

  # Retry failed parts
  if (length(failed_parts) > 0) {
    message(sprintf(
      "Retrying %d failed parts sequentially...",
      length(failed_parts)
    ))
    for (task in failed_parts) {
      tryCatch(
        {
          part_result <- upload_single_part(local_path, task, object)
          parts[[task$part_index + 1]] <- part_result
        },
        error = function(e) {
          message(sprintf(
            "FINAL ERROR: Sequential worker part %s failed after all retries: %s",
            task$part_number,
            e$message
          ))
          stop(e)
        }
      )
    }
  }

  Filter(Negate(is.null), parts)
}

#' Function to support multi-part upload for files larger than multipart_threshold.
#' Enhanced multipart upload with parallel parts and presigned URL refresh
#' @param obj Object created
#' @param local_path Path of file in local
#' @param local_md5 md5sum checksum of file
#' @param num_processes Number of parallel workers for multipart upload (default: 1)
#' @param max_retries Maximum retries per part for multipart upload (default: 3)
#' @param conn Valid EDP connection
#' @inheritDotParams Objects
Multi_part_file_upload <- function(
  obj,
  local_path,
  local_md5,
  num_processes,
  max_retries,
  conn = get_connection(),
  ...
) {
  # Fetching upload ID
  client <- NULL
  if (is.null(client)) {
    client <- obj$client
  }

  # Get presigned urls
  # sHOULD WE ADD try Catch here
  tryCatch(
    {
      presigned_urls <- obj$presigned_urls
      total_parts <- length(presigned_urls)
      cat(
        "Notice: Starting multipart upload with",
        total_parts,
        "parts using",
        num_processes,
        "worker(s)...\n"
      )

      part_tasks <- list()
      file_conn <- file(local_path, "rb")
      for (i in seq_along(presigned_urls)) {
        part_info <- presigned_urls[[i]]

        part_task <- list(
          part_number = part_info$part_number,
          start_byte = part_info$start_byte,
          end_byte = part_info$end_byte,
          part_size = part_info$size,
          upload_url = part_info$upload_url,
          part_index = i,
          max_retries = max_retries,
          upload_id = obj$upload_id,
          upload_key = obj$upload_key
        )

        part_tasks[[length(part_tasks) + 1]] <- part_task
      }

      # Upload in parallel or sequential
      if (num_processes > 1) {
        parts <- upload_parts_parallel(
          local_path = local_path,
          part_tasks = part_tasks,
          object = obj,
          num_processes = num_processes
        )
      } else {
        parts <- upload_parts_sequential(
          local_path = local_path,
          part_tasks = part_tasks,
          object = obj
        )
      }
      cat("Notice: Completing multipart upload....\n")
      complete_data <- list(
        upload_id = obj$upload_id,
        physical_object_id = obj$upload_key,
        parts = parts
      )

      complete_resp <- request_edp_api(
        "POST",
        "v2/complete_multi_part",
        conn = conn,
        params = complete_data
      )

      if ("message" %in% names(complete_resp)) {
        cat(sprintf(
          "Notice: Successfully uploaded %s to %s with multipart upload.\n",
          local_path,
          obj$path
        ))
        return(obj)
      } else {
        stop("Multipart upload failed: ", content(complete_resp, "text"))
      }
    },
    error = function(e) {
      warning("deleting object file because uploading file failed...")
      del <- try(delete(obj, conn = conn), silent = TRUE)
      stop(sprintf("Multipart upload failed: %s", e$message))
    }
  )
}

#' queries the content of a file.
#'
#' The file has to be parsable by EDP. Otherwise you can use [File_download()]
#'
#' @param id    a File ID
#' @inheritParams params
#' @export
File_query <- function(
  id,
  filters = NULL,
  limit = 10000,
  offset = NULL,
  all = FALSE,
  conn = get_connection()
) {
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

  df <- request_edp_api(
    "POST",
    file.path("v2/objects", id, "data"),
    params = params,
    parse_as_df = TRUE,
    conn = conn,
    limit = limit,
    offset = offset,
    total = total
  )
  if (all) {
    df <- fetch_all(df)
  }

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
  request_edp_api(
    "GET",
    file.path("v2/objects", id(file_id), "download"),
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
File_read <- function(
  file_id,
  local_path = tempfile(),
  conn = get_connection(),
  ...
) {
  if (missing(local_path)) {
    on.exit(unlink(local_path), add = TRUE)
  }
  File_download(file_id, local_path, conn = conn, ...)

  readLines(local_path)
}
