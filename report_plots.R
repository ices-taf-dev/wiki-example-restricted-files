## Prepare plots and tables for report

## Before: data/
##           summary_catch.csv
## After: report/
##          sumary_catch.png
##          catches_by_halfyear_bar.png
##          Catches_by_halfyear_stack.png

library(icesTAF)
library(dplyr)
library(tidyr)
library(ggplot2)


mkdir("report")

# read in data
summary_catch <-
  read.taf("data/summary_catch.csv")

# catch time series
taf.png("summary_catch")
print(
  ggplot(data = summary_catch, aes(x = Year, y = Total)) +
    geom_bar(stat = "identity", fill = taf.blue) +
    ylab("Total Catch (t)") +
    theme_minimal()
)
dev.off()


# catches by half year
p_halfyear <-
  summary_catch %>%
    select(-Total) %>%
    gather(Period, Catches, "1st half", "2nd half") %>%
    ggplot(aes(x = Year, y = Catches, fill = Period)) +
    theme_minimal()

taf.png("catches_by_halfyear_stack")
print(
  p_halfyear +
    geom_area(position = 'stack')
)
dev.off()

taf.png("catches_by_halfyear_bar")
print(
  p_halfyear +
    geom_bar(stat = "identity", position=position_dodge())
)
dev.off()
