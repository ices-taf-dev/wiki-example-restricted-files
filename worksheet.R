
library(icesTAF)

# gather data and software

draft.data()

# add restricted data
# first set ices username
icesConnect::set_username("colin")

# fetch token, and store in encrypted keyring, can do this before running taf.boot(),
#   otherwise you will be asked to enter a password while taf.boot() runs
icesConnect::ices_token()

# write script, place in boot/{my_rscript_name}.R, then call
draft.data()
# and create a DATA.bib entry for the script.


# make some software entries
draft.software(c("captioner", "fledge"))

# process DATA and SOFTWARE
taf.boot()

# clean all boot data and software
clean.boot(force = TRUE)


source.taf("data")

# this runs data, model/method, output, report
source.all()




## Prepare official outputs of the analysis - example from SAG
sag_artifact <- function(stock, path) {
  list(
    file = unbox(path),
    type = unbox("sag"),
    metdata = data.frame(code_type = "ICES_StockCode", code = stock)
  )
}

# note for RDBES - we can set up helper functions,
# something like: rdbes_detail_artifact(stock, country, year, path)

library(jsonlite)

artifacts <- c(
  sag_artifact("san.sa.6", "output/sag_upload.xml")
)

write_json(artifacts, path = "ARTIFACTS.json", pretty = TRUE)


# notes:
# for RDBES we need to define
# * types - such as RDBES_detail, and RDBES_summary
# * the metadata requirements
# * the access requirements


# what the server does:

# inputs to process:
# * reponame for cloning
# * username of committer: {username}

# server secrets:
# * skeleton key password, to allow mimic of a user: {skeleton_key_pass}

# 0.1 clone the repository
# 0.2 copy 'taf' files to a working directory

# 1.1. install dependencies
system("Rscript -e con=file('log_deps.txt');sink(con,append=TRUE);sink(con,type='message',append=TRUE);icesTAF::install.deps(repos=c('https://ices-tools-prod.r-universe.dev','https://flr.r-universe.dev','https://cloud.r-project.org'));warnings();sessioninfo::session_info()")

# 1.2. clean bootstrap
system("Rscript -e icesTAF::clean.boot(force=TRUE);warnings()")

# 1.3. run bootstrap script (connecting to ICES api's as the user who committed)
system("Rscript -e icesConnect::set_username({username});icesConnect::ices_token(password = {skeleton_key_pass});con=file('log_bootstrap.txt');sink(con,append=TRUE);sink(con,type='message',append=TRUE);icesTAF::taf.bootstrap();warnings();sessioninfo::session_info();icesConnect::clear_token()")

# 1.3. run bootstrap script (default user)
system("Rscript -e con=file('log_bootstrap.txt');sink(con,append=TRUE);sink(con,type='message',append=TRUE);icesTAF::taf.bootstrap();warnings();sessioninfo::session_info()")

# 1.5. clean assessment
system("Rscript -e icesTAF::clean();warnings()");

# 1.6. run assessment
system("Rscript -e con=file('log.txt');sink(con,append=TRUE);sink(con,type='message',append=TRUE);icesTAF::sourceAll();warnings();sessioninfo::session_info();icesTAF::taf.session()")

# 1.7 process ARTIFACTS.json file

# 2. Copy results into "live" folder, accessible to the file service api

# notes:
# * do not copy boot/initial folder
# * do not copy boot data labelled as "restricted"
