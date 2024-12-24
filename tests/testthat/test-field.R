test_that("format_df_like_model works for list values", {
  # Test case to test columns values as lists with numerical/integer datatypes
  create_model_df_from_fields <- quartzbio.edp:::create_model_df_from_fields

  ### create a fields dummy list
  DATA_TYPES <- c("string", "double", "integer", "long")

  .field <- function(name, title = toupper(name), ordering = NULL, description = "",
                     data_type = DATA_TYPES) {
    list(
      name = name, title = title, description = description, data_type = match.arg(data_type),
      ordering = ordering
    )
  }

  .typefield <- function(type, ordering) {
    .field(name = type, data_type = type, ordering = ordering)
  }
  fields <- mapply(.typefield, DATA_TYPES, seq_along(DATA_TYPES) - 1, SIMPLIFY = FALSE)
  # remove some ordering
  fields$date$ordering <- fields$long$ordering <- NULL
  # add entity type for one filed
  fields$date$entity_type <- "sample_metadata"

  df <- create_model_df_from_fields(DATA_TYPES, fields)
  model <- df
  create_rows <- function(col) {
    col <- toupper(col)
    rows <- switch(col,
      "STRING" = {
        list1 <- c("a1", "a2", "a3")
        list2 <- c("b1", "b2", "b3")
        list3 <- c("c1", "c2", "c3")
        return(list(list1, list2, list3))
      },
      "DOUBLE" = {
        series <- 1:3
        list1 <- c(series + 1.1)
        list2 <- c(series + 2.2)
        list3 <- c(series + 3.3)
        return(list(list1, list2, list3))
      },
      "INTEGER" = list(c(1:3), c(4:6), c(10:15)),
      "LONG" = {
        series <- 47145481:47145483
        list1 <- c(series + 1)
        list2 <- c(series + 2)
        list3 <- c(series + 3)

        return(list(list1, list2, list3))
      }
    )
    names(rows) <- col
    return(rows)
  }

  # Create a dummy dataframe with numerical list values
  .create_df <- function(cols) {
    column_rows <- lapply(cols, create_rows)
    names(column_rows) <- cols

    df <- data.frame(
      matrix(NA,
        nrow = length(column_rows[[1]]),
        ncol = length(column_rows)
      ),
      stringsAsFactors = FALSE
    )
    colnames(df) <- names(column_rows)

    for (col_name in names(column_rows)) {
      df[[col_name]] <- column_rows[[col_name]]
    }
    return(df)
  }

  new_df <- .create_df(DATA_TYPES)

  format_df_like_model <- quartzbio.edp:::format_df_like_model
  df2 <- format_df_like_model(new_df, model)

  expect_identical(dim(df2), dim(new_df))
  # Check correct class assignment when row values are list
  expect_identical(class(df2[[2]]), "list")
  expect_identical(class(df2[[2]][[1]]), "numeric")
  expect_identical(class(df2[[3]][[1]]), "integer")
  expect_identical(class(df2[[4]][[1]]), "integer")
})
