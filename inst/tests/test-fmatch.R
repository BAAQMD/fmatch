context("fmatch")

test_that("Plain strings", {
  x <- c("cat", "dog", "horse")
  y <- c("dog", "bear", "cat")
  r <- fmatch(x, y)
  expect_equal(r, c(3, 1, NA))
})

test_that("Wildcards", {
  x <- c("c?t", "dog", "horse")
  y <- c("d?g", "bear", "cat")
  r <- fmatch(x, y)
  expect_equal(r, c(3, 1, NA))
})

random_word <- function (width, alphabet = c(LETTERS, "?")) {
  ch <- sample(alphabet, width, replace = TRUE)
  paste0(ch, collapse = "")
}

test_that("Speed", {
  dict <- unique(replicate(1e3, random_word(width = 8)))
  words <- sample(dict, 1e4, replace = TRUE)
  expect_that(r <- fmatch(words, dict), takes_less_than(1))
})
