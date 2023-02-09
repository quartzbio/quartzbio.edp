### TODO: be able to fetch tasks for multiple status at one (i.e. work around match.arg() in
# preprocess_api_params


#' fetches a list of tasks.
#' 
#' @inheritParams params
#' @param target_object_id  the object ID to fetch the tasks for
#' @return a list of Tasks as a ECSTaskList object.
#' @export
Tasks <- function(
  target_object_id = NULL,
  parent_task_id = NULL,
  status = NULL,
  alive = NULL,
  limit = NULL, page = NULL,
  conn = get_connection()) 
{
  # currently preprocess_api_params does not support multi-valued params

  params  <- preprocess_api_params(exclude = c('conn', 'limit', 'page', 
    'status', 'parent_task_id', 'alive'))

  if (!.empty(alive)) {
    # can not be used with status
    .die_unless(.empty(status), 'param "alive" can not be used with "status"')
    .die_unless(is.logical(alive) && !is.na(alive), 'bad param "alive": "%s"', alive)
    status  <- if (alive) TASK_STATUS_ALIVE else setdiff(TASK_STATUS, TASK_STATUS_ALIVE)
  }
  if (!.empty(status)) {
    bad <- setdiff(status, TASK_STATUS)
    .die_unless(.empty(bad), 'bad status values: "%s"', bad)
    params$status <- paste0(status, collapse = ',')
  }

  res <- request_edp_api('GET', "v2/tasks", conn = conn, limit = limit, page = page, params = params)

  if (.is_nz_string(parent_task_id)) {
    df <- as.data.frame(res)
    # df$parent_id may be a list with NULL elements
    .good <- function(x) .is_nz_string(x) && x == parent_task_id
    children <- vapply(df$parent_id, .good, logical(1))
    res <- res[children]
  }

  res
}

#' fetches a task.
#' 
#' @inheritParams params
#' @return the tasks as a ECSTask object, or NULL if none found.
#' @export
Task <- function(task_id, conn = get_connection()) 
{
  obj <- request_edp_api('GET', file.path("v2/tasks", id(task_id)), conn = conn)
  # let's bless it explicitly since the class_name attribute seems to be missing
  # cf https://precisionformedicine.atlassian.net/browse/SBP-377
  bless(obj, 'ECSTask')
}

#' Waits for a task to be completed (or failed).
#' 
#' @inheritParams params
#' @return TRUE if the task is finished (completed or failed), or FALSE if the number of retries
#'  is exceeded (~ timeout).
#' @export
Task_wait_for_completion <- function(task_id, interval = 3, retries = 30, recursive = TRUE, 
  conn = get_connection()) 
{
  .task <- function() {
    x <- Task(task_id, conn = conn)
    .die_unless(!.empty(x), 'unable to fetch a task for id="%s"', task_id)
    x
  }

  task <- .task()

  while(Task_is_alive(task)) {
    retries <- retries - 1L
    if (retries < 0) return(NULL) # timeout
    Sys.sleep(interval)

    msg <- .safe_sprintf('waiting for task %s ("%s" for "%s"),  %i retries left', 
      task$id, task$task_display_name, task$target_object$full_path, retries)
    message(msg)
    task <- .task()
  }

  if (recursive) {
    subtasks <- Tasks(parent_task_id = task_id, alive = TRUE, conn = conn)
    for (subtask in subtasks) {
      if (!Task_wait_for_completion(subtask, interval = interval, retries = retries, 
        recursive = TRUE, conn = conn))
        return(FALSE)
    }
  }

  TRUE
}


Task_is_alive <- function(task) task$status %in% TASK_STATUS_ALIVE

#' @export
print.ECSTask <- function(x, ...) {
  lst <- bless(list(x), 'ECSTaskList', 'edplist')
  print(lst)
}


#' @export
print.ECSTaskList <- function(x, ...) {
  cat('EDP List of' , length(x), 'ECSTasks\n')

  df <- as.data.frame(x)
  df$user <- unlist1(elts(df$user, 'full_name'))
  df$target_full_path <- unlist1(elts(df$target_object, 'full_path'))

  cols <- c('id', 'target_full_path', 'task_display_name',  'status', 'description', 'user', 'updated_at')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

