library(devtools)
library(gutenbergr)
library(tidyverse)
library(readxl)

authors = read_xlsx("./source/Authors_Metadata.xlsx", col_names = TRUE)
table(authors$Gender)
png('./results/ActiveDecade.png')
hist(authors$`Active Decade`, breaks = 20,
      xlab = "Active decade", main = "")
dev.off()

languages = gutenberg_languages %>%
  group_by(language) %>%
  summarise(n = sum(total_languages)) %>%
  arrange(desc(n))

works = gutenberg_works()
works = works %>%
  mutate(lastname = gsub(pattern = ",.+", replacement = "", x = author)) %>%
  arrange(lastname)

write_csv(works, file = "./works.csv")

