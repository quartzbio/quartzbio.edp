# Waits for a task to be completed (or failed).

N.B: using retries == 0 will immediately timeout and return FALSE. This
is convenient for unit testing for example

## Usage

``` r
Task_wait_for_completion(
  task_id,
  interval = 3,
  retries = 30,
  recursive = TRUE,
  conn = get_connection()
)
```

## Arguments

- task_id:

  an (ECS) Task ID as a string.

- interval:

  time in seconds to wait before retrying

- retries:

  number of attempts to perform to check the task completion

- recursive:

  whether to also wait for the subtasks

- conn:

  a EDP connection object (as a named list or environment)

## Value

TRUE if the task is finished (completed or failed), or FALSE if the
number of retries is exceeded (~ timeout).
