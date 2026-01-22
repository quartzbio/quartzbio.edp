test_that_with_edp_api(
  "Task_wait_for_completion",
  {
    v <- get_test_vault()

    ds <- Dataset_create(v, "my_dataset")

    records <- list(
      list(gene = "CFTR", importance = 1, sample_count = 2104),
      list(gene = "BRCA2", importance = 1, sample_count = 1391),
      list(gene = "CLIC2", importance = 5, sample_count = 14)
    )
    res <- Dataset_import(ds, records = records)

    # timeout
    expect_false(Task_wait_for_completion(
      res$task_id,
      retries = 1,
      interval = 1
    ))
    expect_false(Task_wait_for_completion(2, retries = 1, interval = 1))

    # print.ECSTaskList()
    tasks <- Tasks(parent_task_id = 1, alive = TRUE)
    expect_identical(length(tasks), 1L)
    lines <- strsplit(capture_output(print(tasks)), "\n")[[1]]
    expect_match(lines[1], "List of 1 ECSTasks")

    # print.ECSTask: currently using print.ECSTaskList()
    expect_output(print(tasks), "EDP List of 1 ECSTasks")
  },
  can_capture = FALSE
)


# if we were to recapture, it is stored in Tasks/tasks-494909.json
#
test_that_with_edp_api(
  "Task",
  {
    v <- get_test_vault()
    tatype <- "datasets.DatasetCommit"
    tas <- Tasks(task_type = tatype)
    expect_identical(unique(unlist1(elts(tas, "task_type"))), tatype)
  },
  can_capture = FALSE
)
