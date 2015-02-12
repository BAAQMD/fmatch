# fmatch

Uses [Rcpp](http://www.rcpp.org) to implement a version of `match` with limited wildcard support.

The implementation could use some love from a real C/C++ programmer. Comments and suggestions are more than welcome!

    library(fmatch)
    library(testthat)
    
    random_word <- function (width, alphabet = c(LETTERS, "?")) {
      ch <- sample(alphabet, width, replace = TRUE)
      paste0(ch, collapse = "")
    }
    
    test_that("Speed", {
      dict <- unique(replicate(1e3, random_word(width = 8)))
      words <- sample(dict, 1e4, replace = TRUE)
      expect_that(r <- fmatch(words, dict), takes_less_than(1))
    })

