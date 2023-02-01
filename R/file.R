

#' fetches a list of files.
#' @inheritParams params
#' @inheritDotParams Objects
#' @export
Files <- function(...) {
  Objects(..., object_type = 'file')
}

#' fetches a file by id, full_path or (vault_id, path)
#' @param id    a File ID 
#' @inheritParams params
#' @return the file info as an Object
#' @export
File <- function(id = NULL, full_path = NULL, path = NULL, vault_id = NULL, 
  conn = get_connection()) 
{
  Object(object_type = 'file', id = id, full_path = full_path, path = path, vault_id = vault_id, 
    conn = conn)
}


#' uploads a file
#' @inheritParams params
#' @export
File_upload <- function(vault_id, local_path, vault_path, 
  mimetype = mime::guess_type(local_path),
  conn = get_connection()) 
{
  vault_id <- id(vault_id)
  .die_unless(file.exists(local_path), 'bad local_path "%s"', local_path)
  size <- file.size(local_path)
  force(mimetype)
  md5 <- tools::md5sum(local_path)[[1]]

  obj <- File_create(vault_id, vault_path, 
    size = size, 
    mimetype = mimetype, 
    md5 = md5,
    conn = conn)

  res <- try(File_upload_content(obj$upload_url, local_path, size = size, mimetype = mimetype, md5 = md5))

  if (.is_error(res) || res$status != 200) {
    warning('deleting object file because uploading file content failed...')
    del <- try(delete(obj, conn = conn), silent = TRUE)
    if (.is_error(del)) {
      message('could not delete the Object ', obj$id, ' : ', .get_error_msg(del))
    }

    err <- get_api_response_error_message(res)
    .die('uploading file content failed with code %s: %s', res$status, err)
  }

  obj
}

File_create <- function(vault_id, vault_path, object_type = 'file', conn = get_connection(), ...) {
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
    ...)
}


File_upload_content <- function(upload_url, path, size, mimetype, md5 = tools::md5sum(path)[[1]]) {
  message('uploading file ', path, '...') 

  encoded_md5 <- jsonlite::base64_enc(hex2raw(md5))
  headers <- c('Content-MD5' = encoded_md5, 'Content-Type' = mimetype, 'Content-Length' = size)

  PUT(upload_url, add_headers(headers), body = upload_file(path, type = mimetype))
}

#' queries the content of a file.
#' 
#' The file has to be parsable by EDP. Otherwise you can use [File_download()] 
#'
#' @param id    a File ID 
#' @inheritParams params
#' @export
File_query <- function(id, filters = NULL, limit = NULL, offset = NULL, all = FALSE, 
    conn = get_connection()) 
{
  id <- id(id)
  params <- list(filters = filters)

  df <- request_edp_api('POST', file.path("v2/objects", id, 'data'), params = params, 
      simplifyDataFrame = TRUE, conn = conn, limit = limit, offset = offset)
  if (all)  df <- fetch_all(df)
  
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
  request_edp_api('GET', file.path("v2/objects", id(file_id), 'download'), postprocess = FALSE, 
    conn = conn)$download_url
}

#' utility function that downloads an EDP File into a local file or in memory
#' 
#' N.B: using the function without the `local_path` param only works reliably for text files.
#' Otherwise please download to file.
#
#' @inheritParams params
#' @param ...  passed to utils::download.file()
#' @return either the file content as a character vector, or NULL if `local_path` is set
#' @export
File_download <- function(file_id, local_path = NULL, conn = get_connection(), ...) {
  url <- File_get_download_url(file_id, conn = conn)
  if (.is_nz_string(local_path)) {
    curl::curl_download(url, local_path)
    return(invisible())
  }
  
  con <- curl::curl(url)
  on.exit(close(con), add = TRUE)
  readLines(con)
}
