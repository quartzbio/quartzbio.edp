#' fetches a list of folders.
#' @inheritParams params
#' @inheritDotParams Objects
#' @return the folders as an ObjectList
#' @export
Folders <- function(...) {
  Objects(..., object_type = "folder")
}

#' fetches a folder by id, full_path or (vault_id, path)
#' @param id      the folder ID.
#' @inheritParams params
#' @export
Folder <- function(
    id = NULL, full_path = NULL, path = NULL, vault_id = NULL,
    conn = get_connection()) {
  Object(
    object_type = "folder", id = id, full_path = full_path, path = path, vault_id = vault_id,
    conn = conn
  )
}

#' creates  a folder.
#' @param path              the folder path to create
#' @param recursive         whether to recursively create the parent folders if they do not exist.
#' @param parent_folder_id  the ID of the parent folder.
#' @inheritParams params
#'
#' @return the folder as an Object
#' @export
Folder_create <- function(
    vault_id, path, recursive = TRUE, parent_folder_id = NULL,
    conn = get_connection()) {
  vault_id <- id(vault_id)
  parent_folder_id <- id(parent_folder_id)
  path <- path_make_absolute(path)
  parent_path <- dirname(path)
  folders <- strsplit(path, "/", fixed = TRUE)[[1]][-1]

  # do we need a parent ?
  if (!length(parent_folder_id) && parent_path != "/") {
    parent <- Folders(path = parent_path, vault_id = vault_id, conn = conn)[[1]]
    .die_if(!length(parent) && !recursive, "not allowed to create parent folder (recursive == FALSE)")
    if (!length(parent)) {
      parent <- Folder_create(vault_id, parent_path, recursive = recursive, conn = conn)
    }
    parent_folder_id <- parent$id
  }
  Object_create(
    vault_id = vault_id, filename = basename(path), object_type = "folder",
    parent_object_id = parent_folder_id, conn = conn
  )
}

# create folder if its path does not exist
# return NULL for "/"
Folder_fetch_or_create <- function(vault_id, path, conn = get_connection()) {
  if (path == "/") {
    return(NULL)
  }

  vault_id <- id(vault_id)

  # must get a folder
  fo <- Folders(path = path, vault_id = vault_id, conn = conn)[[1]]
  if (!length(fo)) {
    # no parent --> create it
    fo <- Folder_create(vault_id, path, conn = conn)
  }

  fo
}
