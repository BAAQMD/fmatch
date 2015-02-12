context("fmatch")

test_that("Plain strings match", {
  x <- c("cat", "dog", "horse")
  y <- c("dog", "bear", "cat")
  r <- fmatch(x, y)
  expect_equal(r, c(3, 1, NA))
})

test_that("Wildcards match", {
  x <- c("c?t", "dog", "horse")
  y <- c("d?g", "bear", "cat")
  r <- fmatch(x, y)
  expect_equal(r, c(3, 1, NA))
})
