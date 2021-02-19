FBFBB <- c("foo", "bar", "foo", "baz", "b?p")

test_that("no wildcards", {
  
  # when a match exists
  expect_equal(fmatch("foo", FBFBB), 1)  # "foo" found at position 1 -> stop and return immediately; don't match position 3
  expect_equal(fmatch("bar", FBFBB), 2)  # "bar" found at position 2
  expect_equal(fmatch("baz", FBFBB), 4)  # "baz" found at position 4
  expect_equal(fmatch("bap", FBFBB), 5)  # "b?p" found at position 5
  
  # when no match exists
  expect_equal(fmatch("zzz", FBFBB), NA_integer_) # "zzz" is not found
  expect_equal(fmatch("", FBFBB), NA_integer_) # "" is not found
  expect_equal(fmatch(NA_character_, FBFBB), NA_integer_) # `NA_character_` is not found
  
})

test_that("improper input throws error", {
  
  expect_error(fmatch(list("foo"), FBFBB))
  expect_error(fmatch(NULL, FBFBB))
  expect_error(fmatch(0.0, FBFBB))
  expect_error(fmatch(0L, FBFBB))
  
})

test_that("single wildcard", {
  
  FBFBB <- c("foo", "bar", "foo", "baz", "bap")
  
  # "f??" matches "foo" at position 1 
  # stop and return immediately
  # don't match position 3 (second instance of "foo")
  expect_equal(fmatch("f??", FBFBB), 1)  
  
  # "ba?" matches "bar" at position 2
  # stop and return immediately
  # don't match position 4 ("baz") or 5 ("bap")
  expect_equal(fmatch("ba?", FBFBB), 2)  
  
})

test_that("two or more wildcards", {
  
  # "??z" matches "baz" at position 4
  expect_equal(fmatch("??z", FBFBB), 4)
  
})

test_that("mismatched string lengths yield NA", {
  
  expect_equal(fmatch("f", FBFBB), NA_integer_)
  expect_equal(fmatch("??", FBFBB), NA_integer_)
  
  # This actually returns `2` with the existing `fmatch()`, 
  # which is the wrong behavior. Oops!
  expect_equal(fmatch("????", FBFBB), NA_integer_)
  
})

test_that("vectorized for `x`` having length > 1", {
  
  expect_equal(fmatch(c("foo", "bar"), FBFBB), c(1, 2))
  expect_equal(fmatch(c("ba?", "??z"), FBFBB), c(2, 4))
  expect_equal(fmatch(c("b?r", "zzz"), FBFBB), c(2, NA_integer_))
  
})
