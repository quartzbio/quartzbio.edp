test_that_with_edp_api("ds_custom_fields", {
  v <- get_test_vault()

  IRIS <- head(iris, 5)
  IRIS$Species <- as.character(IRIS$Species)
  ds <- Dataset_create(v, "/A/custom/iris.ds")

  fields <- quartzbio.edp:::infer_fields_from_df(IRIS)
  # change . to _ and lower case, and change the ordering
  for (i in seq_along(fields)) {
    fields[[i]]$title <- gsub("\\W+", "_", tolower(fields[[i]]$name))
    fields[[i]]$ordering <- length(fields) - i
  }
  # change the type of the first field
  fields[[1]]$data_type <- "integer"

  Dataset_import(ds, df = IRIS, target_fields = fields, sync = httptest_is_capture_enabled())

  ### target_fields have been taken into account
  df <- Dataset_query(ds)
  expect_identical(names(df), c("species", "petal_width", "petal_length", "sepal_width", "sepal_length"))

  ### check that fetch_next() uses the same meta data / format as its source
  df0 <- Dataset_query(ds, limit = 2)

  df1 <- fetch_next(df0)

  # N.B: df1 is properly formatted, just like df and df0!
  expect_equal(df1, df[3:4, ], ignore_attr = TRUE)

  ### fetch_all too
  dfa <- fetch_all(df0)
  expect_equal(dfa, df, ignore_attr = TRUE)
})



test_that_with_edp_api("dataset_query", {
  v <- get_test_vault()
  set.seed(1234)
  IRIS <- iris[sample(nrow(iris), 10), ]
  IRIS$Species <- as.character(IRIS$Species)
  ds <- quartzbio.edp::Dataset_create(v, "/A/b/iris.ds")

  Dataset_import(ds, df = IRIS, sync = httptest_is_capture_enabled())

  ### parallel query
  df <- Dataset_query(ds, limit = 2, all = TRUE)
  expect_equal(df, IRIS, ignore_attr = TRUE)

  ###
  df <- Dataset_query(ds)
  expect_equal(df, IRIS, ignore_attr = TRUE)

  ### filters
  # new style / R style
  df2 <- Dataset_query(ds, filters = filters('Species = "versicolor"'))
  expect_equal(df2, df[df$Species == "versicolor", ], ignore_attr = TRUE)

  # JSON style
  df3 <- Dataset_query(ds, filters = r"([["Species",  "versicolor"]])")
  expect_equal(df3, df2)

  # more complex
  df2 <- Dataset_query(ds, filters = filters('(Species = "virginica") AND (Sepal.Length >= 7)'))
  expect_equal(df2, df[df$Species == "virginica" & df$Sepal.Length >= 7, ], ignore_attr = TRUE)

  ### all = TRUE
  df <- Dataset_query(ds, limit = 2)
  expect_equal(nrow(df), 2)

  df_all <- Dataset_query(ds, limit = 2, all = TRUE)
  expect_equal(nrow(df_all), 10)
  expect_equal(df_all, IRIS, ignore_attr = TRUE)

  ### fetch_next() and filters
  df <- Dataset_query(ds, filters = filters('Species = "virginica"'), limit = 2)
  expect_equal(nrow(df), 2)
  expect_identical(unique(df$Species), "virginica")

  #
  df2 <- fetch_next(df)
  expect_equal(nrow(df2), 2)
  expect_identical(unique(df2$Species), "virginica")
  expect_false(df2[1, 2] == df[1, 2])

  #
  df_all <- Dataset_query(ds, filters = filters('Species = "virginica"'), limit = 2, all = TRUE)
  expect_equal(nrow(df_all), 7)
  expect_identical(unique(df_all$Species), "virginica")

  ### using offset
  df3.2 <- Dataset_query(ds, filters = filters('Species = "virginica"'), limit = 2, offset = 3)
  expect_equal(df3.2, df_all[4:5, ], ignore_attr = TRUE)

  ### fetch_all
  # simulate dplyr::bind_rows error
  trace(dplyr::bind_rows, quote(stop("argh")), print = FALSE)
  on.exit(untrace(dplyr::bind_rows), add = TRUE)

  expect_warning(df_all2 <- fetch_all(df), "got error using dplyr::bind_rows()")
  expect_equal(df_all2, df_all, ignore_attr = TRUE)
})
