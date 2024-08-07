% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/task.R
\name{Tasks}
\alias{Tasks}
\title{fetches a list of tasks.}
\usage{
Tasks(
  target_object_id = NULL,
  parent_task_id = NULL,
  task_type = NULL,
  status = NULL,
  alive = NULL,
  limit = NULL,
  page = NULL,
  conn = get_connection()
)
}
\arguments{
\item{target_object_id}{the object ID to fetch the tasks for}

\item{parent_task_id}{find the children of that task}

\item{task_type}{find tasks of type task_type}

\item{status}{a Task status, one of (running, queued, pending, completed, failed
)}

\item{alive}{whether to select the Tasks that are alive, i.e. not finished
or failed.}

\item{limit}{The maximum number of elements to fetch, as an integer.
See also \code{page}.}

\item{page}{The number of the page to fetch, as an integer. starts from 1.
See also \code{limit}.}

\item{conn}{a EDP connection object (as a named list or environment)}
}
\value{
a list of Tasks as a ECSTaskList object.
}
\description{
fetches a list of tasks.
}
