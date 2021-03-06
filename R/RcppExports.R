# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' Fast string matching with limited wildcard support
#' 
#' @description
#' For each string in `x`, finds the _first_ match in _y_.
#' The character '?' is treated as a wildcard in both `x` and `y`.
#' 
#' @param x character
#' @param y character
#' @return integer positions of matches in \code{y} (\code{NA} indicates no match)
#' 
#' @export
#' 
fmatch <- function(x, y) {
    .Call(`_fmatch_fmatch`, x, y)
}

