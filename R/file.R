

#' fetches a list of files.
#' @inheritParams params
#' @inheritDotParams Objects
#' @export
Files <- function(...) {
  Objects(..., object_type = 'file')
}

#' fetches a file by id, full_path or (vault_id, path)
#' @inheritParams params
#' @return 
#' @export
File <- function(id = NULL, full_path = NULL, path = NULL, vault_id = NULL, 
  conn = get_connection()) 
{
  Object(object_type = 'file', id = id, full_path = full_path, path = path, vault_id = vault_id, 
    conn = conn)
}


#' uploads a file
#' @export
File_upload <- function(vault_id, local_path, vault_path, 
  mimetype = mime::guess_type(local_path),
  conn = get_connection()) 
{
  vault_id <- id(vault_id)
  vault_path <- path_make_absolute(vault_path)
  filename <- basename(vault_path)
  .die_unless(.is_nz_string(filename), 'bad vault_path "%s"', vault_path)
  .die_unless(file.exists(local_path), 'bad local_path "%s"', local_path)
  size <- file.size(local_path)
  force(mimetype)
browser()
  parent_path <- dirname(vault_path)
  fo <- Folder_fetch_or_create(vault_id, parent_path, conn = conn)

  # create object for the file
  obj <- Object_create(vault_id, filename, 
    object_type = 'file', 
    parent_object_id = fo$id,
    size = size, 
    mimetype = mimetype, 
    conn = conn)

  # res <- try(curl_upload(local_path, obj$upload_url))
  res <- try(File_upload_content(obj$upload_url, local_path, size = size, mimetype = mimetype))

  if (.is_error(res) || res$status != 200) {
    warning('deleting object file because uploading file content failed...')
    delete(obj, conn = conn)

    if (.is_error(res)) stop(res)
    err <- get_api_response_error_message(res)
    .die('uploading file content failed with code %s: %s', res$status, err)

  }

  obj
}
# borrowed from wkb:::.hex2raw
hex2raw <- function (hex) 
{
    hex <- gsub("[^0-9a-fA-F]", "", hex)
    if (length(hex) == 1) {
        if (nchar(hex) < 2 || nchar(hex)%%2 != 0) {
            stop("hex is not a valid hexadecimal representation")
        }
        hex <- strsplit(hex, character(0))[[1]]
        hex <- paste(hex[c(TRUE, FALSE)], hex[c(FALSE, TRUE)], 
            sep = "")
    }
    if (!all(vapply(X = hex, FUN = nchar, FUN.VALUE = integer(1)) == 
        2)) {
        stop("hex is not a valid hexadecimal representation")
    }
    as.raw(as.hexmode(hex))
}

File_upload_content <- function(upload_url, path, size, mimetype) {
  message('uploading file ', path, '...') 
  browser()
  md5 <- tools::md5sum(path)[[1]]
  encoded_md5 <- jsonlite::base64_enc(hex2raw(md5))
  headers <- c('Content-MD5' = encoded_md5, 'Content-Type' = mimetype, 'Content-Length' = size)
  httr::with_verbose(PUT(upload_url, add_headers(headers), body = upload_file(path, type = mimetype)))
  #curl_upload(path, upload_url, 
  # httr::RETRY('PUT', upload_url, add_headers(headers), body = upload_file(path, type = mimetype))
}

#' @export
File_read <- function(id, filters = NULL, limit = NULL, offset = 0, conn = get_connection()) {
  params <- list(filters = filters, offset = offset)
  df <- request_edp_api('POST', file.path("v2/objects", id, 'data'), params = params, 
      simplifyDataFrame = TRUE, conn = conn, limit = limit)
  
  if (length(df) && nrow(df))
    attr(df, 'next') <- function() { File_read(id, filters = filters, limit = limit, 
      offset + nrow(df), conn = conn) }

  df
}
