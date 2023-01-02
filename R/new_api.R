# ### 
# ### Folders
# # get folders
# #' @inheritParams params
# #' @export
# Folders <- function(vault_id = NULL, ...) {
#   Objects(object_type = 'folder', vault_id = vault_id, ...)
# }

# # get a folder
# #' @inheritParams params
# #' @export
# Folder <- function(id = NULL, full_path = NULL, path = NULL, vault_id = NULL, 
#   conn = get_connection()) 
# {
#   if (length(id)) return(Object(id = id, conn = get_connection()))

#   lst <- Objects(object_type = 'folder', vault_id = vault_id, vault_full_path = full_path, 
#     path = path)

#   if (!length(lst)) return(NULL) # no result / not found
#   .die_if(length(lst) > 1, 'ERROR, found multiple results') # should not happen

#   lst[[1]]
# }

# #' create folder
# #' @export
# Folder_create <- function(vault_id, path, recursive = TRUE, parent_folder_id = NULL, 
#   conn = get_connection()) 
# {
#   path <- path_make_absolute(path)
#   parent_path <- dirname(path)
#   folders <- strsplit(path, '/', fixed = TRUE)[[1]][-1]
#   if (!length(parent_folder_id) && parent_path != '/') {
#     parent <- Folder(path = parent_path, vault_id = vault_id, conn = conn)
#     .die_if(!length(parent) && !recursive, 'not allowed to create parent folder (recursive == FALSE)')
#     if (!length(parent)) {
#       parent <- Folder_create(vault_id, parent_path, recursive = recursive, conn = conn)
#     }
#     parent_folder_id <- parent$id
#   }
#   Object_create(vault_id = vault_id, filename = basename(path), object_type = 'folder', 
#     parent_object_id = parent_folder_id, conn = conn)
# }

# ### 
# ### files
# # get files
# #' @inheritParams params
# #' @export
# Files <- function(vault_id = NULL, ...) {
#   Objects(object_type = 'file', vault_id = vault_id, ...)
# }

# #' @inheritParams params
# #' @export
# File <- function(id = NULL, full_path = NULL, path = NULL, vault_id = NULL, 
#   conn = get_connection()) 
# {
#   Object(object_type = 'file', id = id, full_path = full_path, path = path, 
#     vault_id = vault_id, conn = conn)
# }


# #' @export
# File_upload <- function(vault_id, local_path, vault_path, 
#   mimetype = mime::guess_type(local_path),
#   conn = get_connection()) 
# {
#   vault_path <- path_make_absolute(vault_path)
#   filename <- basename(vault_path)
#   .die_unless(.is_nz_string(filename), 'bad vault_path "%s"', vault_path)
#   .die_unless(file.exists(local_path), 'bad local_path "%s"', local_path)
#   size <- file.size(local_path)
#   force(mimetype)

#   fo <- Folder_get_or_create_for_object_path(vault_id, vault_path, conn = conn)

#   # create object for the file
#   obj <- Object_create(vault_id, filename, 
#     object_type = 'file', 
#     parent_object_id = fo$id,
#     size = size, 
#     mimetype = mimetype, 
#     conn = conn)
  
#   res <- try(File_upload_content(obj$upload_url, local_path, size = size, mimetype = mimetype, 
#     conn = conn))

#   if (.is_error(res) || res$status != 200) {
#     warning('deleting object file because uploading file content failed...')
#     delete(obj, conn = conn)

#     if (.is_error(res)) stop(res)
#     err <- get_api_response_error_message(res)
#     .die('uploading file content failed with code %s: %s', res$status, err)

#   }

#   obj
# }

# # create folder if needed for file/dataset path
# # can return NULL if no folder is needed (root file)
# Folder_get_or_create_for_object_path <- function(vault_id, path, conn = get_connection()) {
#   parent_path <- dirname(path)
#   if (parent_path == '/') return(NULL)

#   parent_folder_id <- NULL
#   # must get a folder
#   fo <- Folder(path = parent_path, vault_id = vault_id, conn = conn)
#   if (!length(fo)) {
#     # no parent --> create it
#     fo <- Folder_create(vault_id, parent_path, conn = conn)
#   }

#   fo
# }


# File_upload_content <- function(upload_url, path, size, mimetype, conn) {
#   message('uploading file', path, '...') 
#   headers <- c('Content-Type' = mimetype, 'Content-Length' = size)
#   PUT(upload_url, add_headers(headers), body = upload_file(path, type = mimetype))
# }

# #' @export
# File_read <- function(id, filters = NULL, limit = NULL, offset = 0, conn = get_connection()) {
#   params <- list(filters = filters, offset = offset)
#   df <- request_edp_api('POST', file.path("v2/objects", id, 'data'), params = params, 
#       simplifyDataFrame = TRUE, conn = conn, limit = limit)
  
#   if (length(df) && nrow(df))
#     attr(df, 'next') <- function() { File_read(id, filters = filters, limit = limit, 
#       offset + nrow(df), conn = conn) }

#   df
# }




# #' @export
# fetch_next.edpdf <- function(x) {
#   fun <- attr(x, 'next')
#   if (!length(fun)) return(NULL)
#   fun()
# }

# #' @export
# fetch_all <- function(x) {
#   # naive implementation
#   dfs <- list(x)
#   while(length(x <- fetch_next(x))) dfs <- c(dfs, list(x))

#   df <- do.call(rbind.data.frame, dfs)
#   # recompute took
#   took <- sum(sapply(dfs, attr, 'took'))
#   attr(df, 'took') <- took
#   # remove obsolete attributes
#   attr(df, 'offset') <- attr(df, 'next') <- NULL

#   df
# }


# #' @export
# print.edplist <- function(x, ...) {
#   cat('EDP List of' , length(x), 'objects')

#   if (length(x)) {
#     cl <- class(x[[1]])[1]
#     if (.is_nz_string(cl))
#       cat(' of type', cl)

#     cat('\n')
#     df <- convert_edp_list_data_to_df(x)
#     print(df)
#   } else {
#     cat('\n')
#   }
# }


# ### 
# ### vaults
# #' vaults
# #' @export
# Vaults <- function(
#   vault_type = c('personal', 'general'),
#   tag = NULL,
#   user_id = NULL,
#   storage_class = NULL,
#   limit = NULL, page = NULL, conn = get_connection()) 
# {
#   params  <- list()
#   if (.is_nz_string(vault_type)) params$vault_type <- vault_type
#   if (.is_nz_string(tag)) params$tags <- tag
#   if (length(user_id)) params$user_id <- user_id
#   if (.is_nz_string(storage_class)) params$storage_class <- storage_class
#   request_edp_api('GET', "v2/vaults", conn = conn, limit = limit, page = page, params = params)
# }


# #' @inheritParams params
# #' @export
# Vault <- function(id = NULL, full_path = NULL, name = NULL,  conn = get_connection()) 
# {
#   by <- list(id = id, full_path = full_path, name = name)
#   # no arg ==> fetch personal vault
#   if (all(lengths(by) == 0)) {
#     return(vault_fetch_personal(conn = conn))
#   }
#   lst <- get_by("v2/vaults", by = by, conn = conn)

#   .die_if(class(lst) != 'Vault' && length(lst) > 1, 'returned multiple vaults')
#   if (!length(lst)) lst <- NULL

#   lst
# }

# #' cf https://docs.solvebio.com/reference/vaults/vaults/#create
# #' @export
# Vault_create <- function(name,  
#   description = NULL,
#   metadata = NULL,
#   tags = NULL,
#   default_storage_class = NULL,
#   conn = get_connection()) 
# {
#   params <- preprocess_api_params()
#   request_edp_api('POST', "v2/vaults", conn = conn, params = params)
# }

# #' @export
# Vault_update <- function(id,  
#   name = NULL,
#   description = NULL,
#   metadata = NULL,
#   tags = NULL,
#   default_storage_class = NULL,
#   conn = get_connection()) 
# {
#   params <- preprocess_api_params()
#   request_edp_api('PUT', file.path("v2/vaults", id), conn = conn, params = params)
# }

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



# vault_fetch_personal <- function(conn = get_connection()) {
#   userid <- User(conn = conn)$id
#   params <- list(name = paste("user", userid, sep = "-"), vault_type = "user")
#   request_edp_api('GET', "v2/vaults", conn = conn, params = params)[[1]]
# }

# Vault_delete <- function(id, conn = get_connection()) {
#   request_edp_api('DELETE', file.path("v2/vaults", id), conn = conn)
# }

# #' @export
# update.Vault <- function(object, conn = get_connection(), ...) {
#   Vault_update(object$id, conn = conn, ...)
# }

# #' @export
# update.VaultId <- function(object, conn = get_connection(), ...) {
#   Vault_update(object, conn = conn, ...)
# }

# #' @export
# delete.Vault <- function(x, conn = get_connection()) {
#   Vault_delete(x$id, conn = conn)
# }

# #' @export
# delete.VaultId <- function(x,  conn = get_connection()) {
#   Vault_delete(x, conn = conn)
# }

# #' @export
# print.Vault <- function(x, ...) {
#   msg <- sprintf('Vault "%s" @ %s (%s), user:%s updated at:%s', 
#     x$name, x$full_path, x$vault_type, x$user$full_name,x$updated_at)
#   cat(msg, '\n')
# }

# #' @export
# print.VaultList <- function(x, ...) {
#   cat('EDP List of' , length(x), 'Vaults\n')
#   df <- as.data.frame(x)
#   df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

#   cols <- c('id', 'name', 'full_path', 'user_name', 'vault_type', 'created_at')

#   cols <- intersect(cols, names(df))
#   df <- df[cols]
  

#   print(df)
# }

# #' @export
# fetch.VaultId <- function(x,  conn = get_connection()) {
#   Vault(x, conn = conn)
# }


# ### 
# ### objects
# #' @inherit Object.all
# #' @inheritParams params
# #' @export
# Objects <- function(
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
#   conn = get_connection(), limit = NULL, page = NULL) 
# {
#   params  <- preprocess_api_params()
#   request_edp_api('GET', "v2/objects", conn = conn, limit = limit, page = page, params = params)
# }

# #' @inherit Object.retrieve
# #' @inheritParams params
# #' @export
# Object <- function(id = NULL, full_path = NULL, path = NULL,  vault_id = NULL, 
#   conn = get_connection()) 
# {
  
#   get_by("v2/objects", 
#     by = list(id = id, full_path = full_path, vault_path = list(vault_id = vault_id, path = path)), 
#     conn = conn)
# }


# #' @export
# Object_create <- function(
#   vault_id,
#   filename,
#   object_type,
#   parent_object_id = NULL,
#   description = NULL,
#   metadata = NULL,
#   tags = NULL,
#   storage_class = NULL,
#   mimetype = NULL,
#   size = NULL,
#   conn = get_connection()) 
# {
#   params <- preprocess_api_params()
#   request_edp_api('POST', 'v2/objects', conn = conn, params = params)
# }

# #' @export
# Object_update <- function(id,  
#   filename = NULL ,
#   object_type = NULL,
#   parent_object_id = NULL,
#   description = NULL,
#   metadata = NULL,
#   tags = NULL,
#   storage_class = NULL,
#   conn = get_connection()) 
# {
#   params <- preprocess_api_params()
#   request_edp_api('PUT', file.path('v2/objects', id), conn = conn, params = params)
# }

# Object_delete <- function(id, conn = get_connection()) {
#   request_edp_api('DELETE', file.path("v2/objects", id), conn = conn)
# }

# get_by <- function(path, by = list(), conn = NULL, ...) {
#   keys <- names(by)

#   # process sublists
#   .is_set <- function(x) {
#     if (is.list(x)) {
#       # a sublist is set if all its items are set, otherwise it is an error
#       nb_set <- sum(lengths(x) == 1)
#       if (nb_set == 0) return(FALSE)
#       .die_unless(nb_set == length(x), 'all items "%s" must be set', names(x))
#       return(TRUE)
#     }

#     length(x) == 1
#   }
  
#   with_values <- sapply(by, .is_set)
#   nb_set <- sum(with_values)

#   .die_unless(nb_set == 1, 'you must exactly one parameter among %s', keys)

#   params <- list(...)
#   key <- keys[with_values]
#   value <- by[[key]]
 
#   if (key == 'id') {
#     path <- file.path(path, value)
#   } else {
#     if (is.list(value)) {
#       params <- value 
#     } else {
#       params[[key]] <- value
#     }
#   }

#   o <- request_edp_api('GET', path, conn = conn,  params = params)
#   if (key != 'id') {
#     if (!length(o)) return(NULL)
#     o <- o[[1]]
#   }

#   o
# }



# #' @export
# fetch.ObjectId <- function(x,  conn = get_connection()) {
#   Object(id = x, conn = conn)
# }


# #### Object methods
# #' @export
# delete.Object <- function(x, conn = get_connection()) {
#   Object_delete(x$id, conn = conn)
# }

# #' @export
# delete.ObjectId <- function(x, conn = get_connection()) {
#   Object_delete(x, conn = conn)
# }

# #' @export
# print.Object <- function(x, ...) {
#   count <- x$documents_count
#   if (!length(count)) count <- 0L
#   msg <- .safe_sprintf('%s "%s" (%s) nb:%i user:%s accessed:%s', 
#     x$object_type, x$full_path, x$mimetype, count, x$user$full_name, x$last_accessed)
#   cat(msg, '\n')
# }

# #' @export
# print.ObjectList <- function(x, ...) {
#   cat('EDP List of' , length(x), 'Objects\n')

#   df <- as.data.frame(x)
#   df$user_name <- sapply(df$user, getElement, 'full_name', USE.NAMES = FALSE)

#   cols <- c('path', 'object_type', 'vault_name',  'user_name', 'object_type', 'last_modified')
#   cols <- intersect(cols, names(df))
#   df <- df[cols]
  
#   print(df)
# }

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

# #' @inherit Dataset.retrieve
# #' @inheritParams params
# #' @export
# Dataset <- function(id, conn = get_connection()) {
#   path <- paste("v2/datasets", paste(id), sep="/")
#   request_edp_api('GET', path, conn = conn)
# }

# #' @export
# Dataset_create <- function(
#   vault_id,
#   name,
#   fields = NULL,
#   vault_parent_object_id = NULL,
#   description = NULL,
#   metadata = NULL,
#   tags = NULL,
#   storage_class = NULL,
#   capacity = NULL,
#   conn = get_connection()) 
# {
#   if (!length(vault_parent_object_id)) {
#     vault_parent_object_id <- Folder_get_or_create_for_object_path(vault_id, name, conn)$id
#   }
#   name <- basename(name)
#   params <- preprocess_api_params()
#   request_edp_api('POST', 'v2/datasets', conn = conn, params = params)
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
# #   convert_edp_list_data_to_df(x)
# # }


# ###
# ### user

#' fetches  user information
#' @inheritParams params
#' @return the connected user information as a User object
#' @export
User <- function(conn = get_connection()) {
  request_edp_api('GET', "v1/user", conn = conn)
}

# #' @export
# print.User <- function(x, ...) {
#   msg <- sprintf('EDP user "%s"(%s) role:%s', 
#     x$full_name, x$username, x$role)
#   cat(msg, '\n')
# }

# #' @export
# fetch_vaults.User <- function(x,  conn = get_connection()) {
#   Vaults(user_id = x$id, conn = conn)
# }

# #' @export
# fetch_vaults.UserId <- function(x,  conn = get_connection()) {
#   Vaults(user_id = x, conn = conn)
# }

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
#     df <- convert_edp_list_data_to_df(x)
#     print(df)
#   } else {
#     cat('\n')
#   }
# }




# ###
# ### ================================= FILTERS
# # substitute_operators <- function(lst) {
# #   # message(as.character(lst))

# #   if (!length(lst)) return(lst)
# #   if (is.symbol(lst)) {
# #     op <- as.character(lst)
# #     if (startsWith(op, '%'))
# #     op <- tolower(gsub('%', '', op))
# #     return(op)
# #   }
# #   if (!is.list(lst)) return(lst)
  
# #   lapply(lst, substitute_operators)
# # }

# lst2filter <- function(lst) {
#   if (!length(lst)) return(lst) 
#   if (length(lst) == 2 && lst[[1]] == '(') return(lst2filter(lst[[2]]))
#   op <- as.character(lst[[1]])
#   op <- tolower(gsub('%', '', op))
  
#   if (op %in% c('or', 'and')) {
#     conds <- lapply(lst[-1], lst2filter)
#     res <- list(conds)
#     names(res) <- op
#     return(res)
#   }
#   if (length(lst) != 3) return(lst)

#   # should be an a binary operator
#   lhs <- as.character(lst[[2]])
#   op <- as.character(lst[[1]])
#   if (op != '=') {
#     op <- tolower(gsub('%', '', op))
#     lhs <- paste0(lhs, '__', op)
#   }
#   rhs <- lst[[3]]
#   if (length(rhs) && is.symbol(rhs[[1]]) && as.character(rhs[[1]]) == 'c')
#     rhs <- rhs[-1]
#   list(lhs, rhs)
# }

# #' @export
# parse_filter <- function(fil) {
#   `%CONTAINS%` <- 'contains'
#   `%AND%` <- 'and'
#   `%OR%` <- 'or'
#   `%IN%` <- 'in'

#   for (op in c('AND', 'OR', 'CONTAINS', 'IN')) {
#     pattern <- paste0('\\s+', op, '\\s+')
#     replace <- paste0(' %', op, '% ')
#     fil <- gsub(pattern, replace, fil)
#   }

#   expr <- parse(text = fil)
#   lst <- qbcode::code_to_list(expr)
#   # lst2 <- substitute_operators(lst)

#   list(lst2filter(lst))
# }