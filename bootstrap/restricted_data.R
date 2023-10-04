# this is a example of accessing a web api using a token

library(icesTAFDB)

# this test function (should) print out your ices username and some other info
out <- icesTAFDB::test()

if (FALSE) {
  # not yet developed, but to get RDBES intermediate files, it would
  # look like this:
  rdbes_dk <-
    icesTAFDB::getArtifacts(
      type = "RDBES_detail",
      ISO_3166 = "DK",
      ICES_StockCode = "cod.27.46a7d20",
      Year = 2023,
      repository = "2023_all_RDBES_DK"
    )
}

# write this to a file
cat(out, file = "silly_example.txt")
