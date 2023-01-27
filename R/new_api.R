






# # vault_create_or_update <- function(id = NULL, name = NULL, description = NULL,
# #   metadata = NULL,
# #   tags = NULL, 
# #   default_storage_class = c('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive'),
# #   conn = get_connection(),
# #   ...) 
# # {
# #   params <- list()
# #   if (.is_nz_string(name)) params$name <- name
# #   if (length(default_storage_class)) {
# #     default_storage_class <- match.arg(default_storage_class)
# #     if (.is_nz_string(default_storage_class)) params$default_storage_class <- default_storage_class
# #   }
# #   if (.is_nz_string(description)) params$description <- description
# #   if (.is_nz_string(tags)) params$tags <- tags
# #   if (length(metadata)) params$metadata <- metadata

# #   method <- 'POST'
# #   path <-"v2/vaults"
# #   if (length(id)) {
# #     method <- 'PUT'
# #     path <- file.path(path, id)
# #   }

# #   request_edp_api(method, path, conn = conn, params = params, ...)
# # }



# ###(
# ### datasets

# #' @inherit Dataset.all
# #' @inheritParams params
# #' @export
# Datasets <- function(
#   vault_id = NULL,
#   vault_name = NULL,
#   vault_full_path = NULL,
#   filename = NULL,
#   path = NULL,
#   object_type = NULL,
#   depth = NULL,
#   query = NULL,
#   regex = NULL,
#   glob = NULL,
#   ancestor_id = NULL,
#   min_distance = NULL,
#   tag = NULL,
#   storage_class = NULL,
#   conn = get_connection(), 
#   limit = NULL, 
#   page = NULL) 
# {
#   lst <- Objects(vault_id = vault_id, vault_name = vault_name, vault_full_path = vault_full_path, 
#     filename = filename, path = path, object_type = 'dataset', depth = depth, 
#     query = query, regex = regex, glob = glob, ancestor_id = ancestor_id, 
#     min_distance = min_distance, tag = tag, storage_class = storage_class, 
#     conn = conn, limit = limit, page = page)
#   class(lst) <- c('DatasetList', class(lst))

#   lst
# }



# #' @export
# print.Dataset <- function(x, ...) {
#   count <- x$documents_count
#   if (!length(count)) count <- 'NA'
#   msg <- .safe_sprintf('Dataset "%s", %s documents, updated at:%s', 
#     x$vault_object_path, count, x$updated_at)
#   cat(msg, '\n')
# }

# #' @export
# print.DatasetList <- function(x, ...) {
#   cat('EDP List of' , length(x), 'Datasets\n')

#   df <- as.data.frame(x)
#   df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

#   cols <- c('path',  'documents_count', 'vault_name',  'user_name', 'last_modified')
#   cols <- intersect(cols, names(df))
#   df <- df[cols]
  
#   print(df)
# }

# #' @export
# fetch.DatasetId <- function(x,  conn = get_connection()) {
#   Dataset(x, conn = conn)
# }

# #' @export
# fetch.UserId <- function(x,  conn = get_connection()) {
#   User(x, conn = conn)
# }


# # as.data.frame.Object <- function(x, row.names = NULL, optional = FALSE, ...) {
# #   convert_edp_list_to_df(x)
# # }


# ###
# ### edplist
# #' @export
# print.edplist <- function(x, ...) {
#   cat('EDP List of' , length(x), 'objects')

#   if (length(x)) {
#     cl <- class(x[[1]])[1]
#     if (.is_nz_string(cl))
#       cat(' of type', cl)

#     cat('\n')
#     df <- convert_edp_list_to_df(x)
#     print(df)
#   } else {
#     cat('\n')
#   }
# }

