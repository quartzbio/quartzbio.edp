

#' fetches a list of vaults
#'
#' @inheritParams params
#' @export
Vaults <- function(
  vault_type = NULL,
  tags = NULL,
  user_id = NULL,
  storage_class = NULL,
  limit = NULL, page = NULL, 
  conn = get_connection()) 
{
  by <- preprocess_api_params()
  fetch_by("v2/vaults", by = by, limit = limit, page = page, all = TRUE, unique = FALSE, conn = conn)
}

#' fetches a vault
#' 
#' N.B: 
#'   - if called without `id`, `full_path` or `name`, it fetches the *personal vault* 
#'      of the connected user.
#'   - dies if multiple vaults are matched
#' 
#' @param id          the Vault ID or object to fetch
#' @param full_path   the full path of the vault to fetch
#' @param name        the name of the the vault to fetch
#' @inheritParams params
#' @return the vault as a list with class `Vault`, or NULL if no matching vault is found 
#' @export
#' @examples \dontrun{
#' # with no argument, fetch the connected user personal vault
#' v <- Vault()
#' 
#' # by id
#' v2 <- Vault(v$id)
#' 
#' # by full_path
#' v2 <- Vault(full_path = v$full_path)
#' 
#' # by name
#' v2 <- Vault(name = "Public")
#' 
#' }
Vault <- function(id = NULL, full_path = NULL, name = NULL, conn = get_connection()) 
{
  id <- id(id)
  by <- list(id = id, full_path = full_path, name = name)
  # no arg ==> fetch personal vault
  if (all(lengths(by) == 0)) return(vault_fetch_personal(conn = conn))
  
  lst <- fetch_by("v2/vaults", by = by, conn = conn)

  .die_if(class(lst) != 'Vault' && length(lst) > 1, 'returned multiple vaults')
  if (!length(lst)) lst <- NULL

  lst
}

#' creates a new EDP vault.
#' 
#' cf https://docs.solvebio.com/reference/vaults/vaults/#create
#' 
#' @param name  the vault name to create, as a string.
#' @inheritParams params
#' @export
#' @examples \dontrun{
#' # simplest form
#' v <- Vault_create('my.new.vault')
#' 
#' # using all params
#' v <- Vault_create(name = 'my.new.vault', 
#'    description = 'This is my own vault', 
#'    metadata = list(a = 1, b = 'toto', sublist = list(x = 'str')), 
#'    tags = c('TEST', 'DATA'), 
#'    storage_class = 'Performance', 
#'    conn = conn)
#' 
#' }
Vault_create <- function(name,  
  description = NULL,
  metadata = NULL,
  tags = NULL,
  storage_class = NULL,
  conn = get_connection()) 
{
  if (length(tags)) tags <- as.list(tags)
  
  params <- preprocess_api_params()
  
  # rename storage_class as default_storage class
  params$default_storage_class <- params$storage_class
  params$storage_class <- NULL

  request_edp_api('POST', "v2/vaults", conn = conn, params = params)
}

#' update a vault (TODO)
#' @inheritParams params
#' @export
Vault_update <- function(id,  
  name = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  default_storage_class = NULL,
  conn = get_connection()) 
{
  params <- preprocess_api_params()
  request_edp_api('PUT', file.path("v2/vaults", id), conn = conn, params = params)
}

# vault_create_or_update <- function(id = NULL, name = NULL, description = NULL,
#   metadata = NULL,
#   tags = NULL, 
#   default_storage_class = c('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive'),
#   conn = get_connection(),
#   ...) 
# {
#   params <- list()
#   if (.is_nz_string(name)) params$name <- name
#   if (length(default_storage_class)) {
#     default_storage_class <- match.arg(default_storage_class)
#     if (.is_nz_string(default_storage_class)) params$default_storage_class <- default_storage_class
#   }
#   if (.is_nz_string(description)) params$description <- description
#   if (.is_nz_string(tags)) params$tags <- tags
#   if (length(metadata)) params$metadata <- metadata

#   method <- 'POST'
#   path <-"v2/vaults"
#   if (length(id)) {
#     method <- 'PUT'
#     path <- file.path(path, id)
#   }

#   request_edp_api(method, path, conn = conn, params = params, ...)
# }



vault_fetch_personal <- function(conn = get_connection()) {
  userid <- User(conn = conn)$id
  params <- list(name = paste("user", userid, sep = "-"), vault_type = "user")
  request_edp_api('GET', "v2/vaults", conn = conn, params = params)[[1]]
}

Vault_delete <- function(id, conn = get_connection()) {
  request_edp_api('DELETE', file.path("v2/vaults", id), conn = conn)
}

#' @export
update.Vault <- function(object, conn = get_connection(), ...) {
  Vault_update(object$id, conn = conn, ...)
}

#' @export
update.VaultId <- function(object, conn = get_connection(), ...) {
  Vault_update(object, conn = conn, ...)
}

#' @export
delete.Vault <- function(x, conn = attr(x, 'connection')) {
  Vault_delete(x$id, conn = conn)
}

#' @export
delete.VaultId <- function(x,  conn = get_connection()) {
  Vault_delete(x, conn = conn)
}

#' @export
print.Vault <- function(x, ...) {
  perms <- summary_string(x$permissions)
  msg <- .safe_sprintf('Vault "%s" ("%s", %s, %s), @ "%s", updated at:%s', 
    x$full_path, x$description, x$vault_type, perms, x$user$full_name,x$updated_at)
  cat(msg, '\n')
}

#' @export
print.VaultList <- function(x, ...) {
  cat('List of' , length(x), 'Vaults\n')
  df <- as.data.frame(x)
  df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

  cols <- c('id', 'name', 'full_path', 'user_name', 'vault_type', 'created_at')

  cols <- intersect(cols, names(df))
  df <- df[cols]
  

  print(df)
}

#' @export
fetch.VaultId <- function(x,  conn = attr(x, 'connection')) {
  Vault(x, conn = conn)
}
