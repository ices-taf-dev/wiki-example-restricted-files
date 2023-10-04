## Extract results of interest, write TAF output tables

## Before: data/
##           summary.csv
## After: output/
##          sag_upload.xml,
##          sag_info.csv,
##          sag_fishdata.csv

library(icesTAF)
library(icesSAG)

mkdir("output")

# read in summary data
summary <- read.taf("data/summary_catch.csv")

# create SAG inputs
sag_info <-
  stockInfo(
    StockCode = "san.sa.6",
    AssessmentYear = 2019,
    ContactPerson = "someone@fishlab.world",
    Purpose = "Advice",
    StockCategory = 5,
    ModelType = "None",
    ModelName = "None"
  )
sag_info$RecruitmentAge <- 0

sag_fishdata <-
  stockFishdata(Year = summary$Year, Catches = summary$Total)

sag_upload <- createSAGxml(sag_info, sag_fishdata)
cat(sag_upload, file = "output/sag_upload.xml")


# write out summary data as csv
sag_info <- as.data.frame(sag_info)
write.taf(sag_info, dir = "output")
write.taf(sag_fishdata, dir = "output")
