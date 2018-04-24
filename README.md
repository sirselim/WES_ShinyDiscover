# WES_ShinyDiscover
A Shiny interface to filter and identify variants of interest from whole exome data

## Configure the `home` directory

This is the directory that contains all the results files (from [VCF-DART]()) to be viewed.

The user is required to edit the appropriate line in the `global.R` file:

```R
# set directory to search for results files
HOMEDIR <- "/home/grcnata/"
addResourcePath("homeDir", HOMEDIR)
res.list <- list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T)
MutAssess.links <- list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T)
```