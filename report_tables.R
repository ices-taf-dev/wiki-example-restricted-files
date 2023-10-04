## Prepare plots and tables for report

## Before: output/
##           summary_catch.csv
## After: report/
##          summary_catch.csv
##          summary_catch.html

library(icesTAF)
library(dplyr)
library(htmlTable)

mkdir("report")

# read in data and round
summary_catch <-
  read.taf("data/summary_catch.csv") %>%
  rbind(colMeans(.)) %>%
  round %>%
  mutate(Year = c(paste(Year)[-nrow(.)], "arith. mean"))

# write table
write.taf(summary_catch, dir = "report", quote = TRUE)

# write out as html
summary_catch_html <-
  htmlTable(summary_catch, rnames = FALSE,
            caption = "Sandeel. Total catch (tonnes) by area, first and second half year as estimated by ICES.")
cat(summary_catch_html, file = "report/summary_catch.html")
