library(tidyverse)

set.seed(2021)

# filter to median length words only
# want to avoid the early out taking so long
words = read_csv("/usr/share/dict/words") %>%
  filter(nchar(A) == 9) %>%
  sample_n(1000) 

haystacks = as.character(words$A)
needles = sample(haystacks, 1000)

fmatch(needles, haystacks)
