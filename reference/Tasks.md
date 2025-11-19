# fetches a list of tasks.

fetches a list of tasks.

## Usage

``` r
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
```

## Arguments

- target_object_id:

  the object ID to fetch the tasks for

- parent_task_id:

  find the children of that task

- task_type:

  find tasks of type task_type

- status:

  a Task status, one of (running, queued, pending, completed, failed )

- alive:

  whether to select the Tasks that are alive, i.e. not finished or
  failed.

- limit:

  The maximum number of elements to fetch, as an integer. See also
  `page`.

- page:

  The number of the page to fetch, as an integer. starts from 1. See
  also `limit`.

- conn:

  a EDP connection object (as a named list or environment)

## Value

a list of Tasks as a ECSTaskList object.
