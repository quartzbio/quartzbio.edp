
# do we need size and limit ? 
# size = min(total, limit)
# so it we know size and total, limit >= size
# ==> size is enough
# total shoud probably be mandatory. 
new_page_index <- function(size, total, offset = NULL, page = NULL) {
  .die_unless(is_defined_scalar_integer(size) && size > 0, 'bad size')
  .die_unless(is_defined_scalar_integer(total) && total > 0, 'bad total')

  .die_unless(size <= total, '"size" > "total"')

  if (!.empty(offset)) {
    .die_unless(is_defined_scalar_integer(offset) && offset >= 0, 'bad offset')
    .die_unless(.empty(page), 'you can not give both offset and page')
    page <- offset_to_page(offset, size)
  } else {
    if (.empty(page)) page <- 1L 
    .die_unless(is_defined_scalar_integer(page) && page > 0, 'bad page')
  }

  list(index = page, size = size, total = total)
}

offset_to_page <- function(offset, size) { ceiling(offset / size) + 1 }
page_to_offset <- function(page, size) {  (page - 1) * size }


# util
#' @export 
pager <- function(x) attr(x, 'pager')
