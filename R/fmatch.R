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
fmatch = function(needles, haystacks)
{
  stopifnot(class(needles) == "character")
  
  ret = numeric()
  for (i in 1:length(needles))
  {
    needle = needles[i]
    if (is.na(needle))
    {
      ret = c(ret, NA_integer_)
      next
    }

    converted <- convert_needle_to_regex(needle)
    needle_nchar <- nchar(needle)
    
    found = FALSE
    for (j in 1:length(haystacks))
    {
      if (needle_nchar == nchar(haystacks[j]))
      {
        if (str_detect(haystacks[j], converted))
        {
          found = TRUE
          ret = c(ret, j)
          break
        }
      } 
    }
    if (!found) 
    {
      ret = c(ret, NA_integer_)
    }
  }
  ret
}

# converting a needle to "regex" is complex because the domain fmatch
# is used in treats "?" as a wildcard. However, regex does has its own
# wildcard character. Additionally, fmatch supports wildcards in both 
# needle and haystack. But regex really only supports wildcards in the 
# needle.
# as such, convert_needle_to_haystack does two things:
# 1. convert each occurence of "?" to "." 
#    In regex "." means "match every character except a newline".
# 2. convert each other character "x" to "[x?]". In regex "[]" means
#    "character class", and the extra "?" means "also match "?" 
#    (which, again, is the fmatch wildcard)
# see https://github.com/rstudio/cheatsheets/blob/master/strings.pdf
convert_needle_to_regex = function(needle)
{
  ret = ""
  for (i in 1:nchar(needle))
  {
    char = substr(needle, i, i)
    if (char == "?") # the wildcard in needle
    {
      # in regex, "." means "every character except a newline. 
      ret = paste0(ret, ".")
    } else {
      # [] denotes a character class
      # here the class has 2 elements: the original char and ? 
      # (the wildcard in haystack)
      char_with_wildcard = paste0("[", char, "?]")
      ret = paste0(ret, char_with_wildcard)
    }
  }
  ret
}
