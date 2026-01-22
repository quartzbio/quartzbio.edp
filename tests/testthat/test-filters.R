test_that("eval_numeric_litterals", {
  eval_numeric_litterals <- quartzbio.edp:::eval_numeric_litterals
  code_to_list <- quartzbio.edp:::code_to_list

  ###
  lst <- code_to_list(parse(text = "c(-1, 2, -3, +4)"))
  expect_identical(eval_numeric_litterals(lst[-1]), list(-1, 2, -3, 4))

  expect_identical(eval_numeric_litterals(list(as.symbol("-"), 1)), -1)
  expect_identical(eval_numeric_litterals(1), 1)
  expect_identical(eval_numeric_litterals(list(1)), list(1))
})


# .filters <- function()
test_that("filters", {
  ### edge cases
  expect_identical(filters(NULL), list(NULL))
  # debugonce(quartzbio.edp:::lst2filter)
  expect_identical(
    filters("list(1)"),
    list(quartzbio.edp:::code_to_list(quote(list(1))))
  )

  # unknown numeric litteral op
  expect_error(filters("LHS = ~0.1"), "do not know what to do with symbol")

  ### = --> special op that uses the EDP default
  expect_identical(
    filters('Sepal.Length = "7"')[[1]],
    list("Sepal.Length", "7")
  )
  expect_identical(filters("Sepal.Length = 7")[[1]], list("Sepal.Length", 7))
  expect_identical(
    filters("Sepal.Length = -1.2")[[1]],
    list("Sepal.Length", -1.2)
  )
  expect_identical(filters('LHS = ""')[[1]], list("LHS", ""))

  ### String filters
  expect_identical(
    filters('LHS exact "litteral"')[[1]],
    list("LHS__exact", "litteral")
  )
  expect_identical(
    filters('LHS iexact "litteral"')[[1]],
    list("LHS__iexact", "litteral")
  )

  expect_identical(filters('LHS in ("L1")')[[1]], list("LHS__in", list("L1")))
  expect_identical(
    filters('LHS in ("L1", "L2")')[[1]],
    list("LHS__in", list("L1", "L2"))
  )

  expect_identical(
    filters('LHS contains "litteral"')[[1]],
    list("LHS__contains", "litteral")
  )
  expect_identical(
    filters('LHS regexp "litteral"')[[1]],
    list("LHS__regexp", "litteral")
  )

  ### numeric filters
  expect_identical(filters("LHS in (1)")[[1]], list("LHS__in", list(1)))
  expect_identical(filters("LHS in (1, -2)")[[1]], list("LHS__in", list(1, -2)))

  expect_identical(
    filters("LHS range (-1, 3)")[[1]],
    list("LHS__range", list(-1, 3))
  )

  expect_identical(filters("LHS gt 3.5")[[1]], list("LHS__gt", 3.5))
  expect_identical(filters("LHS > 3.5")[[1]], list("LHS__gt", 3.5))
  expect_identical(filters("LHS gte -0.1")[[1]], list("LHS__gte", -0.1))

  expect_identical(filters("LHS >= -0.1")[[1]], list("LHS__gte", -0.1))
  expect_identical(filters("LHS lt 0")[[1]], list("LHS__lt", 0))
  expect_identical(filters("LHS < 0")[[1]], list("LHS__lt", 0))
  expect_identical(filters("LHS lte - 0.01")[[1]], list("LHS__lte", -0.01))
  expect_identical(filters("LHS <= - 0.01")[[1]], list("LHS__lte", -0.01))

  ################# combining filters ##############################################
  # not
  expect_identical(filters("not (LHS = 7)"), list(list(not = list("LHS", 7))))
  expect_identical(filters("! (LHS = 7)"), list(list(not = list("LHS", 7))))
  expect_identical(filters("!(LHS = 7)"), list(list(not = list("LHS", 7))))

  # and
  x <- '(LHS1  in ("L1", "L2")) and (LHS2 gte -0.1)'
  expect_identical(
    filters(x),
    list(
      list(
        and = list(
          list("LHS1__in", list("L1", "L2")),
          list("LHS2__gte", -0.1)
        )
      )
    )
  )

  # and, or, ambiguous
  x <- '(LHS1  in ("L1", "L2")) and (LHS2 gte -0.1) or (LHS3 contains "litteral")'
  expect_identical(
    filters(x),
    list(
      list(
        or = list(
          list(
            and = list(
              list("LHS1__in", list("L1", "L2")),
              list("LHS2__gte", -0.1)
            )
          ),
          list("LHS3__contains", "litteral")
        )
      )
    )
  )

  # non-ambiguous
  x <- '(LHS1  in ("L1", "L2")) and ((LHS2 gte -0.1) or (LHS3 contains "litteral"))'
  expect_identical(
    filters(x),
    list(
      list(
        and = list(
          list("LHS1__in", list("L1", "L2")),
          list(
            or = list(
              list("LHS2__gte", -0.1),
              list("LHS3__contains", "litteral")
            )
          )
        )
      )
    )
  )

  x <- '(LHS1  in ("L1", "L2")) and (not ((LHS2 gte -0.1) or (LHS3 contains "litteral")))'
  expect_identical(
    filters(x),
    list(
      list(
        and = list(
          list("LHS1__in", list("L1", "L2")),
          list(
            not = list(
              or = list(
                list("LHS2__gte", -0.1),
                list("LHS3__contains", "litteral")
              )
            )
          )
        )
      )
    )
  )
})


test_that("code_to_list", {
  code_to_list <- quartzbio.edp:::code_to_list

  ### edge cases
  # should not be called with NULL anyway
  expect_null(code_to_list(NULL))
  expect_identical(code_to_list(NA), list(NA))

  ### just a symbol
  lst <- code_to_list(quote(x))
  expect_type(lst, "list")
  expect_length(lst, 1)
  expect_true(is.symbol(lst[[1]]))

  ### simple call
  lst <- code_to_list(quote(f()))
  #  expect_true(attr(lst, 'call'))

  lst <- code_to_list(quote(f(NA_character_)))
  #  expect_true(attr(lst, 'call'))
  expect_identical(as.character(lst[[1]]), "f")
  expect_true(is.symbol(lst[[1]]))

  expect_identical(code_to_list(quote(1L)), list(1L))

  expect_identical(code_to_list(quote(1)), list(1))

  expect_identical(code_to_list(quote("toto")), list("toto"))

  ## expression
  expr <- expression(f(x + 1) + 2)
  lst <- code_to_list(expr)
  lst2 <- code_to_list(quote(f(x + 1) + 2))
  expect_identical(lst, lst2)

  f <- function(x, y = 2, z = list(3)) {
    for (i in 1:x) {
      y <- y + i
    }
    g(x + y)
    while (1) {
      f(z)
    }
    y <- "litteral"
    3L + 1
  }
  code <- body(f)
  lst <- code_to_list(code)

  tokens <- as.character(unlist(lst))
  expected <- c(
    "`:`",
    "`{`",
    "`+`",
    "`<-`",
    "`for`",
    "`while`",
    "1",
    "3",
    "f",
    "g",
    "i",
    "litteral",
    "x",
    "y",
    "z"
  )

  expect_identical(sort(unique(tokens)), sort(expected))
  types <- sapply(unlist(lst), mode)
  expect_identical(sort(unique(types)), c("character", "name", "numeric"))

  ### pairlists (args)

  ### (x, y = 2, z = list(3))
  code <- formals(f)

  lst <- code_to_list(code)
  expect_type(lst, "list")
  expect_length(lst, 3)
  #  expect_null(attr(lst, 'call'))

  # x is missing, replaced by its symbol
  expect_identical(lst[[1]], as.symbol("pairlist")) # dummy call
  expect_identical(lst[[2]], 2)
  #  expect_true(attr(lst[[3]], 'call'))
  expect_identical(lst[[3]][[1]], as.symbol("list"))
  expect_identical(lst[[3]][[2]], 3)

  #### another missing case
  code <- quote(x[])
  lst <- code_to_list(code)
  expect_identical(lst[[1]], as.symbol("["))
  expect_identical(lst[[2]], as.symbol("x"))
  expect_null(lst[[3]])
  #  expect_true(attr(lst, 'call'))

  ### and another one
  code <- quote(db[ind, , drop = FALSE])

  lst <- code_to_list(code)

  expect_length(lst, 5)
  expect_identical(lst[[1]], as.symbol("["))
  expect_identical(lst[[2]], as.symbol("db"))
  expect_identical(lst[[3]], as.symbol("ind"))
  expect_null(lst[[4]])
  expect_identical(lst[[5]], FALSE)
})
