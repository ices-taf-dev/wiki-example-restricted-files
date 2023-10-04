## Preprocess data, write TAF data tables

## Before: bootstrap/
##           data/
##             sandeel_assessment_1982_2018.csv
## After: data/
##          summary_catch.csv

library(icesTAF)
library(dplyr)
library(tidyr)

mkdir("data")

# read in input data
catches <- read.taf("bootstrap/data/sandeel_assessment_1982_2018.csv")

# subset out data for area 6, reshape and format
summary_catch <-
  catches %>%
  filter(Area == 6 & year >= 1983) %>%
  select(hy, year, ton) %>%
  spread(hy, ton) %>%
  rename(Year = year, "1st half" = "1", "2nd half" = "2") %>%
  mutate(Total = `1st half` + `2nd half`)

# save
write.taf(summary_catch, dir = "data")
