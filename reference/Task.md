# fetches a task.

fetches a task.

## Usage

``` r
Task(task_id, conn = get_connection())
```

## Arguments

- task_id:

  an (ECS) Task ID as a string.

- conn:

  a EDP connection object (as a named list or environment)

## Value

the tasks as a ECSTask object, or NULL if none found.
