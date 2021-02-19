#' raw_cmp_wild_
#' 
#' Compare two **length-one** character strings, treated as raw, allowing for wildcards in either one.
#' 
#' @seealso `fmatch()`, which depends on `compare_`
#' 
raw_cmp_wild_ <- function (x, y, wildcard = "?") {
  
  if (length(x) * length(y) != 1) return(NA)
  
  raw_wildcard <- charToRaw(wildcard)
  raw_x <- charToRaw(x)
  raw_y <- charToRaw(y)
  
  x_equals_y <- (raw_x == raw_y)
  x_is_wild <- (raw_x == raw_wildcard)
  y_is_wild <- (raw_y == raw_wildcard)
  
  cmp <- (x_equals_y | x_is_wild | y_is_wild)
  
  return(all(cmp == TRUE))
  
}
