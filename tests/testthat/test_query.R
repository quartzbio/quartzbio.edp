context("Test Dataset.query")

test_that("Query the dataset and check that titles are colnames in df", {
  assert_api_key()
  # user <- User.retrieve(env=env)
  user <- User.retrieve()
  expect_true(nzchar(user$email))
  dsl <- Datasets()
  ds <- Dataset.get_by_full_path(dsl[[1]]$full_path)
  fields <- DatasetFields(ds)
  fields_h <- as.list(sort(names(fields)))
  expect_warning(
    query <- Dataset.query(
      ds$id,
      fields = fields_h[1:2],
      use_field_titles = TRUE
    ),
    "only the first page"
  )
  expect_true(any(fields_h %in% colnames(query)))
})
