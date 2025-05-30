# either die, return TRUE if all good, or the early return value
# Error Code 	Meaning 	Description
# 400 	Bad Request 	Your request was malformed
# 401 	Unauthorized 	Your API key or token is invalid
# 403 	Forbidden 	Your API key or token is not valid for this type of request
# 404 	Not Found 	The specified resource could not be found
# 405 	Method Not Allowed 	Your request used an invalid method
# 429 	Too Many Requests 	You have reached the rate limit
# 500 	Internal Server Error 	We had a problem with our server
# 503 	Service Unavailable 	We are temporarily offline for maintenance
check_httr_response <- function(res) {
  status <- res$status
  # 204: no content, 301: moved permanently, 302: Moved Temporarily
  if (status == 204 || status == 301 || status == 302) {
    return(res)
  }
  if (status == 404) { # Not found
    return(NULL)
  }

  if (status >= 200 && status < 400) { # no error
    # check content-type
    content_type <- res$headers$`Content-Type`
    if (!.is_nz_string(content_type) || content_type != JSON) {
      return(res)
    }
    return(TRUE)
  }

  # .die_if(status == 429,
  #   "API error: Too many requests, please retry in %s seconds", res$header$"retry-after")

  .die_if(
    status == 401,
    "Unauthorized: %s (error %s)", get_api_response_error_message(res), status
  )

  .die_if(status == 400, "API error: %s", get_api_response_error_message(res))

  .die("Uknown API error %s: %s", status, get_api_response_error_message(res))
}


postprocess_df <- function(res, key, conn) {
  df <- edpdf(res[[key]])
  # store other items as attributes
  items <- setdiff(names(res), c(key, "class", "class_name"))
  for (attr in items) {
    # fix for NULL attributes that should NOT be NULL
    value <- res[[attr]] %IF_EMPTY_THEN% NA
    attr(df, attr) <- value
  }

  attr(df, "connection") <- as.environment(conn)


  df
}

# 3 main cases:
# - result for one object/entity
# - results for a list of objects/entitities
# - results for some data as a dataframe
postprocess_response <- function(res, is_df, conn, call = NULL) {
  # dispatch
  class_name <- res$class_name
  if (!.is_nz_string(class_name)) class_name <- ""

  if (!"total" %in% names(res) && class_name != "list") {
    # consider it is a single entity
    return(postprocess_single_entity(res, conn))
  }

  ### results are either in $data or $results
  key <- intersect(names(res), c("data", "results"))
  .die_if(length(key) == 0, "got NEITHER data NOR results in response")
  .die_if(length(key) > 1, "got BOTH data AND results in response")

  value <- res[[key]]

  x <- if (is_df) {
    postprocess_df(res, key, conn)
  } else {
    postprocess_entity_list(res, key, conn)
  }

  x
}



# process a response that contains only a single entity: classify it, and classify its ids
postprocess_single_entity <- function(res, conn) {
  res <- classify_entity(res)
  res <- apply_class_to_ids(res, detect_ids(res))
  attr(res, "connection") <- as.environment(conn)

  res
}

# return a edplist
postprocess_entity_list <- function(res, key, conn) {
  lst <- res[[key]]
  if (!length(lst)) {
    return(NULL)
  }
  lst <- lapply(lst, classify_entity)
  # decorate objects
  id_classes <- detect_ids(lst[[1]])
  lst <- lapply(lst, apply_class_to_ids, id_classes)

  # check what kind of objects are in the list
  lst <- edplist(lst)
  if (length(lst)) {
    if ("class_name" %in% names(lst[[1]])) {
      class_obj <- lst[[1]]$class_name
      if (.is_nz_string(class_obj)) {
        class(lst) <- c(paste0(class_obj, "List"), class(lst))
      }
    }
  }

  # store other items as attributes on the edp list
  items <- setdiff(names(res), c(key, "class", "class_name"))
  for (attr in items) {
    attr(lst, attr) <- res[[attr]]
  }

  conn <- as.environment(conn)
  attr(lst, "connection") <- conn
  for (i in seq_along(lst)) {
    attr(lst[[i]], "connection") <- conn
  }

  lst
}


# try to parse some details about an API error, as provided by the API in the response
get_api_response_error_message <- function(res, default_message = "") {
  parsed <- try(httr::content(res), silent = TRUE)
  if (.is_error(parsed)) {
    return("Error parsing API response")
  }
  if (!length(parsed)) {
    return(default_message)
  }

  msg <- default_message
  if ("details" %in% names(parsed)) {
    msg <- parsed$details
  } else {
    # backwards compatibility
    msg <- paste0(unlist(parsed), collapse = ", ")
  }

  msg
}


detect_ids <- function(x) {
  # look for ids
  is_id <- grepl("_id$", names(x)) & lengths(x) > 0

  # extract the part before _id (e.g. dataset_id --> dataset)
  class_names <- sub("_.+$", "", names(is_id[is_id]))
  # capitalize, e.g. dataset --> Dataset
  class_names <- capitalize(class_names)
  # suffix with Id
  class_names <- paste0(class_names, "Id")

  current_classes <- lapply(names(is_id[is_id]), function(name) class(x[[name]]))

  for (i in seq_along(current_classes)) {
    current_classes[[i]] <- c(class_names[i], current_classes[[i]])
  }

  current_classes
}


apply_class_to_ids <- function(lst, id_classes) {
  # cols <- intersect(names(id_classes), names(lst))
  for (col in names(id_classes)) {
    v <- lst[[col]]
    if (length(v)) {
      class(lst[[col]]) <- id_classes[[col]]
    }
  }

  lst
}


# add a class to an EDP entity, using it $class_name item
classify_entity <- function(x) {
  if (!is.list(x)) {
    return(x)
  }

  class_name <- x$class_name
  if (!.is_nz_string(class_name)) {
    return(x)
  }

  if (class_name != "list") {
    # special case for objects
    if (class_name == "Object") {
      class(x) <- c(capitalize(x$object_type), "Object", class(x))
    } else {
      class(x) <- c(class_name, class(x))
    }
  }

  x
}
