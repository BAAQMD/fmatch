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
fmatch = function(x, y)
{
  for (i in 1:length(y))
  {
    if (stringr::str_detect(y[i], convert_to_wildcard(x)))
    {
      return(i)
    }
  }
  NA_integer_
}

# take a string such as "hi"
# convert it to "[h?][i?]"
# in regular expressions, this means that each character in the string
# will now match to both its original value AND the character ?
# this is important because, for our purposes,
# ? is a wildcard character in the haystack string
convert_to_wildcard = function(x)
{
  ret = ""
  for (i in 1:nchar(x))
  {
    char = substr(x, i, i)
    char_with_wildcard = glue::glue("[{char}?]")
    ret = paste0(ret, char_with_wildcard)
  }
  ret
}
