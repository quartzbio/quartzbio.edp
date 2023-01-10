


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
