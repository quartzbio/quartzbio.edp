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
  status = NULL,
  limit = NULL, page = NULL,
  conn = get_connection()) 
{
  params  <- preprocess_api_params()
  request_edp_api('GET', "v2/tasks", conn = conn, limit = limit, page = page, params = params)
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
Task_wait_for_completion <- function(task_id, interval = 2, retries = 30, conn = get_connection()) 
{
  .task <- function() {
    x <- Task(task_id, conn = conn)
    .die_unless(!.empty(x), 'unable to fetch a task for id="%s"', task_id)
    x
  }

  task <- .task()
  NOT_FINISHED <- c("pending", "queued", "running")
  nb_retries <- 0
  while(task$status %in% NOT_FINISHED) {
    nb_retries <- nb_retries + 1L
    if (nb_retries > retries) return(NULL) # timeout
    Sys.sleep(interval)

    msg <- .safe_sprintf('waiting for task %s ("%s" for "%s"), attempt #%i/%i', 
      task$id, task$task_display_name, task$target_object$full_path, nb_retries, retries)
    message(msg)
    task <- .task()
  }

  task
}


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

  cols <- c('target_full_path', 'task_display_name',  'status', 'description', 'user', 'updated_at')
  cols <- intersect(cols, names(df))
  df <- df[cols]
  
  print(df)
}

