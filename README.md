# VCF-DART Viewer (VCF file Diagnostics Annotation and Reporting Tool Viewer)
A Shiny interface to filter and identify variants of interest from NGS variant data in VCF file format.

## Configure the `home` directory

This is the directory that contains all the results files (from [VCF-DART](https://github.com/sirselim/diagnostics_exome_reporting)) to be viewed.

The user is required to edit the appropriate line in the `global.R` file:

```R
# set directory to search for results files
HOMEDIR <- "/home/grcnata/"
addResourcePath("homeDir", HOMEDIR)
res.list <- list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T)
MutAssess.links <- list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T)
```

## To-do list / feature list

  - [x] ~~add ability to generate html links to NCBI for variants with RS numbers~~