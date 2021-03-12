library(inventory)

RY_data <-
  RY(2011) %>%
  DB_point_source_emissions()

haystacks <- str_replace_all(with(t0130, paste0(c1_8, c9_12)), "X", "?")

SAMPLE_SIZES <- c(1, 3, 10, 30, 100, 300, 1e3, 3e3, 10e3, 30e3, 100e3, 300e3)

time_it <- function (sample_size = 1, times = 3) {
  sampled_data <- sample_n(RY_data, sample_size, replace = TRUE)
  needles <- str_replace_all(with(sampled_data, paste0(src_code, SIC_id)), "X", "?")
  microbenchmark::microbenchmark(fmatch(needles, haystacks), times = times)
}

timings <-
  map(SAMPLE_SIZES, time_it)

timing_data <-
  tibble(
    size = SAMPLE_SIZES,
    nanoseconds = map(timings, pluck, "time")) %>%
  tidyr::unchop(
    nanoseconds)

timing_data %>%
  ggplot(aes(size, nanoseconds / 1e9, group = size)) +
  geom_point(alpha = I(0.5)) +
  scale_x_log10("sample size", limits = c(1, 1e7), expand = expansion(0, 1)) +
  scale_y_log10("time (seconds)", limits = c(1e-4, 1e3)) +
  annotate("point", shape = "+", x = 3e4, y = 3, color = "darkgreen", size = I(10)) +
  labs(
    title = "Scalability of fmatch::fmatch()",
    subtitle = str_c(
      "Points are timings via microbenchmark::microbenchmark().",
      "Needles are 12-character strings derived from RY2011 data (concatenations of `cat_id` and `SIC_id`).",
      "X axis (\"sample size\") is the number of needles.",
      "There are about 750 haystacks (derived from `Ingres::t0130`). Haystacks are also 12-character strings.",
      "The green cross is the target (~3 seconds to match 30k 12-char needles against 750 12-char haystacks)",
      sep = "\n"))

