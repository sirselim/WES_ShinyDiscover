# required packages
library("biomaRt")

# load pre saved global data to speed up app load time
load("global_load_data.RData")

# set directory to search for results files
HOMEDIR <- "/home/grcnata/"
#HOMEDIR <- "."
addResourcePath("homeDir", HOMEDIR)
res.list <- list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T)
MutAssess.links <- list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T)

# get current day/date
file.time <- format(Sys.time(), "%a_%b_%d_%Y")