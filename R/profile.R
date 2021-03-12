library(tidyverse)
words = read_csv("/usr/share/dict/words")

haystacks = sample_n(words, 10000)
needles = sample_n(haystacks, 100)

haystacks = haystacks$A
needles = needles$A

fmatch(needles, haystacks)
