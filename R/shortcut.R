#' fetches a list of shortcuts.
#' @inheritParams params
#' @inheritDotParams Objects
#' @return the shortcuts as an ObjectList
#' @export
Shortcuts <- function(...) {
  Objects(..., object_type = "shortcut")
}

#' fetches a shortcut by id or (vault_id, path)
#' @param id      the shortcut ID.
#' @inheritParams params
#' @export
Shortcut <- function(
  id = NULL,
  path = NULL,
  vault_id = NULL,
  conn = get_connection()
) {
  Object(
    object_type = "shortcut",
    id = id,
    path = path,
    vault_id = vault_id,
    conn = conn
  )
}

#' creates  a shortcut.
#' @inheritParams params
#'
#' @details
#' Shortcuts cannot be created to: \itemize{
#'  \item the containing vault of the shortcut file.
#'  \item the parent folder or any ancestor of the shortcut file.
#'  \item a deleted object
#'  \item a non-existent object
#'  \item vaults that are not of type 'general'}
#'
#' @return the shortcut as an Object
#' @export
Shortcut_create <- function(
  vault_id,
  vault_path,
  target,
  tags = list(),
  conn = get_connection()
) {
  vault_id <- id(vault_id)

  allow_target_names <- c("object_type", "id", "url")
  valid_target <- all(names(target) %in% allow_target_names) &&
    ifelse(
      target[["object_type"]] == "url",
      utils::hasName(target, "url"),
      utils::hasName(target, "id")
    )

  .die_unless(valid_target, "Invalid target configuration")

  vault_id <- id(vault_id)
  vault_path <- path_make_absolute(vault_path)
  filename <- basename(vault_path)
  .die_unless(.is_nz_string(filename), 'bad vault_path "%s"', vault_path)

  parent_path <- dirname(vault_path)
  fo <- Folder_fetch_or_create(vault_id, parent_path, conn = conn)

  Object_create(
    vault_id = vault_id,
    filename = filename,
    parent_object_id = fo$id,
    object_type = "shortcut",
    target = target,
    tags = tags,
    conn = conn
  )
}

#' Is an object a shortcut
#'
#' @param obj `Object`
#'
#' @returns Bool
#' @export
#'
is_shortcut <- function(obj) {
  utils::hasName(obj, "object_type") &&
    obj[["object_type"]] == "shortcut"
}

#' Get Shortcut target
#'
#' Resolves the target of a shortcut into its object type.
#'
#' @inheritParams is_shortcut
#' @param allow_null_target Bool (Optional). If False will raise an error instead of returning NULL
#'
#' @returns Object of type `Vault` or `Object` or `character` or `NULL` depending on the target
#' @export
Shortcut_get_target <- function(obj, allow_null_target = TRUE) {
  .die_unless(is_shortcut(obj), "Only shortcut objects have a target resource.")

  target <- obj[["target"]]

  if (!length(target)) {
    if (allow_null_target) {
      return(NULL)
    }
    .die("Shortcut target not found.")
  }

  if (target[["object_type"]] == "url") {
    target[["url"]]
  } else if (target[["object_type"]] == "vault") {
    Vault(id = target[["id"]])
  } else {
    Object(id = target[["id"]])
  }
}
