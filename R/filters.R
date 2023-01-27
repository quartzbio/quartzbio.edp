LOGICAL_OPERATORS <- c('and', 'or')
BINARY_OPERATORS <- list(
    `=` = NULL,
    `exact` = 'exact',
    `iexact` = 'iexact',
    `in` = 'in',
    `iexact` = 'iexact',
    `range` = 'range',
    `gt` = 'gt',
    `>` = 'gt',
    `lt` = 'lt',
    `<` = 'lt',
    `gte` = 'gte',
    `>=` = 'gte', 
    `lte` = 'lte',
    `<=` = 'lte', 
    `contains` = 'contains',
    `regexp` = 'regexp',
    `and` = 'and',
    `or` = 'or'
)
UNARY_OPERATORS <- list(not = '!')

#' parses the maths-like syntax of filters.
#' 
#' @inheritParams params
#' @return the download URL as a string
#' @export
filters <- function(x) {
  fil <- x

  env <- environment()
  for (op in names(BINARY_OPERATORS)) {
    pattern <- paste0('\\s+', op, '\\s+')
    r_operator <- paste0(' %', op, '% ')
    fil <- gsub(pattern, r_operator, fil, ignore.case = TRUE)

    if (!op %in% LOGICAL_OPERATORS) {
      # rewrite RHS list to c()
      pattern <- paste0(r_operator, '\\(')
      replace <- paste0(r_operator, 'c(')
      fil <- gsub(pattern, replace, fil, ignore.case = TRUE)
    }

    # assign r_operator in env
    assign(r_operator,  BINARY_OPERATORS[[op]], envir = env)
  }

  for (op in names(UNARY_OPERATORS)) {
    pattern <- paste0(op, '\\s+')
    r_operator <- UNARY_OPERATORS[[op]]
    fil <- gsub(pattern, r_operator, fil, ignore.case = TRUE)
    # assign r_operator in env
    # assign(r_operator,  op, envir = env)
  }

 
  expr <- try(parse(text = fil), silent = TRUE)

  .die_if(.is_error(expr), 'Syntax Error in the filter string <<%s>>: "%s"', x, .get_error_msg(expr))
    
  lst <- code_to_list(expr)
  # lst2 <- substitute_operators(lst)

  list(lst2filter(lst))
}

lst2filter <- function(lst) {
  if (!length(lst)) return(lst)

  if (length(lst) == 2) {
    op <- as.character(lst[[1]])

    if (op == '(') {
      # ( xxxx )
      return(lst2filter(lst[[2]]))
    }
    
    if (op == '!') {
      return(list(not = lst2filter(lst[[2]])))
    }
  }

  op <- as.character(lst[[1]])
  op <- tolower(gsub('%', '', op))
  
  if (op %in% LOGICAL_OPERATORS) {
    conds <- lapply(lst[-1], lst2filter)
    res <- list(conds)
    names(res) <- op
    return(res)
  }
  if (length(lst) != 3) return(lst) # no op

  # should be an a binary operator
  lhs <- as.character(lst[[2]])
  op <- as.character(lst[[1]])
  op <- gsub('%', '', op)

  replace_op <- BINARY_OPERATORS[[op]]
  if (length(replace_op)) {
    lhs <- paste0(lhs, '__', replace_op)
  }

  ### RHS
  rhs <- lst[[3]]

  if (length(rhs)) {
    if (is.symbol(rhs[[1]])) {
      # is it a vector ? 
      symbol <- as.character(rhs[[1]])
      if (symbol == 'c') {
        rhs <- rhs[-1]
      }
    }

    # must evaluate rhs to eval "-"  or "+" R numeric ops
    rhs <- eval_numeric_litterals(rhs)
  }
  #     browser()

  list(lhs, rhs)
}

eval_numeric_litterals <- function(x) {
  if (!is.list(x) || !length(x)) return(x)

  # the only case to process is if the first element is a symbol
  e1 <- x[[1]]
  if (is.symbol(e1)) {
    op <- as.character(e1)
    if (op == '-') return(-x[[2]])
    if (op == '+') return(x[[2]])
    .die('do not know what to do with symbol "%s"', op)
  }

  lapply(x, eval_numeric_litterals)
}

### borrowed from qbcode
code_to_list <- function(code) {
  if (length(code) == 0) return(NULL)

  if (is.expression(code)) code <- as.call(code)[[1]]

  # not recursive, i.e. just a symbol or litteral
  if ((!is.call(code) && !is.pairlist(code)) || is.symbol(code))
    return(list(code))

  code_to_list_rec(code)
}

# this the actual core of code_to_list(): explore recursively the code
code_to_list_rec <- function(call) {

  # convert the pairlist if any to a dummy call
  if (is.pairlist(call)) {
    call <- pairlist_to_call(call)
  }

  # preallocate results
  lst <- vector(mode = 'list', length = length(call))

  for (i in seq_along(call)) {
    item <- call[[i]]
    # it may be missing, e.g in quote(x[])-> do not include it
    if (missing(item)) next;
    # test if scalar (i.e. not recursive)
    if (!(is.call(item) || is.pairlist(item)))
      lst[[i]] <- item
    else
      lst[[i]] <- Recall(item)
  }

  lst
}