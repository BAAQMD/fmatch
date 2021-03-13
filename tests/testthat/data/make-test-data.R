library(inventory)

RY_data <-
  RY(2011) %>%
  DB_point_source_emissions()

strings <-
  RY_data %>%
  unite(string, src_code, SIC_id, sep = "") %>%
  pull(string)

write_rds(
  strings,
  here::here("tests", "testthat", "data", "strings.Rds"))
  
patterns <- 
  t0130 %>%
  unite(pattern, c1_8, c9_12, sep = "") %>%
  pull(pattern) %>%
  str_replace_all("X", "?")

write_rds(
  patterns,
  here::here("tests", "testthat", "data", "patterns.Rds"))
