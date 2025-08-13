# nocov start
#' Task.all
#'
#' Retrieves the metadata about all tasks on QuartzBio EDP accessible to the current user.
#'
#' @param env (optional) Custom client environment.
#' @param ... (optional) Additional query parameters.
#'
#' @examples \dontrun{
#' Task.all()
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
Task.all <- function(env = get_connection(), ...) {
  .request("GET", "v2/tasks", query = list(...), env = env)
}

#' Task.retrieve
#'
#' Retrieves the metadata about a specific task on QuartzBio EDP.
#'
#' @param id The ID of a task.
#' @param env (optional) Custom client environment.
#'
#' @examples \dontrun{
#' Task.retrieve("1234567890")
#' }
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @importFrom lifecycle deprecate_soft
#' @concept  quartzbio_api
#' @export
Task.retrieve <- function(id, env = get_connection()) {
  deprecate_soft("1.0.0", "Task.retrieve()", "Task()")
  if (missing(id)) {
    stop("A task ID is required.")
  }

  path <- paste("v2/tasks", paste(id), sep = "/")
  .request("GET", path = path, env = env)
}


#' Task.follow
#'
#' A helper function to follow a specific task until it gets completed.
#'
#' @param id String The ID of a task.
#' @param env (optional) Custom client environment.
#' @param interval 2. Delay in seconds between each completion status query
#'
#' @examples \dontrun{
#' Task.follow("1234567890")
#' }
#' @return the task object
#'
#' @references
#' \url{https://docs.solvebio.com/}
#'
#' @concept  quartzbio_api
#' @export
Task.follow <- function(id, env = get_connection(), interval = 2) {
  imp <- Task.retrieve(id, env)
  while (imp$status == "pending" || imp$status == "queued" || imp$status == "running") {
    imp <- Task.retrieve(id, env)
    cat(paste("Task", id, "status:", imp$status, "\n", sep = " "))
    Sys.sleep(interval)
  }
  return(imp)
}
# nocov end
