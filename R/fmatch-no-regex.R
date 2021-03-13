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
fmatch_no_regex = function(needles, haystacks)
{
  stopifnot(class(needles) == "character")
  
  ret = numeric()
  for (i in 1:length(needles))
  {
    if (is.na(needles[i]))
    {
      ret = c(ret, NA_integer_)
      next
    }
    
    found = FALSE
    for (j in 1:length(haystacks))
    {
      if (fmatch_comp(needles[i], haystacks[j]))
      {
        found = TRUE
        ret = c(ret, j)
        break
      }
    }
    if (!found) 
    {
      ret = c(ret, NA_integer_)
    }
  }
  ret
}

fmatch_comp = function(needle, haystack)
{
  if (nchar(needle) != nchar(haystack))
  {
    return(FALSE)
  }
  for (i in 1:nchar(needle))
  {
    needle_char = substr(needle, i, i)
    if (needle_char == "?")
    {
      next
    }
    haystack_char = substr(haystack, i, i)
    if (haystack_char == "?")
    {
      next
    }
    if (needle_char == haystack_char) 
    {
      next
    }
    return(FALSE)
  }
  return(TRUE)
}
