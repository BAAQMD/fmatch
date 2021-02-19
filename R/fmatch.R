#' fmatch
#' 
#' Reference implementation, to illustrate correct behavior.
#' 
#' @param x character vector
#' @param y character vector
#' @return integer vector
#' 
#' @details
#' For each element of `x`, `fmatch(x, y)` yields the position of the *first* match in `y`.
#' If more than one match exists, `fmatch()` will not find the second, third, etc.
#' The value `NA_integer` represents "no matches".
#' 
#' The character "?" is treated as a wildcard in *both* `x` and `y`. There are no other
#' wildcards. "?" will match any single character, including "?".
#' 
#' The return value, which is an integer vector, always has the same length as `x`.
#' 
#' Strings with different lengths (like "f?" and "foo") are not considered matches.
#' 
#' @export
fmatch <- function (x, y) {
  fmatch_R(x, y)
}

fmatch_R <- function (x, y) {

  stopifnot(
    is.character(x), length(x) > 0,
    is.character(y), length(y) > 0)
  
  # This is cheating, because characters can be multibyte.
  # But, it illustrates the right behavior.
  
  result <- rep(NA_integer_, length(x))
  
  for (i in seq_along(x)) {
    is_match <- FALSE
    for (j in seq_along(y)) {
      if (isTRUE(raw_cmp_wild_(x[i], y[j]))) {
        is_match <- TRUE
        break
      }
    }
    result[i] <- j
  }
  
  return(result)
  
}

