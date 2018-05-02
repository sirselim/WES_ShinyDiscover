# VCF-DART Viewer (VCF file Diagnostics Annotation and Reporting Tool Viewer)
A Shiny interface to filter and identify variants of interest from NGS variant data in VCF file format.

The tool uses custom gene lists to categorise variants into specific analysis tiers and to subcategorise them based on standard parameters to facilitate the rapid interrogation of potentially pathogenic variants by human operators. For more information see our [manuscript](https://www.authorea.com/users/21564/articles/298265-a-customisable-scripting-system-for-identification-and-filtration-of-clinically-relevant-genetic-variants-in-whole-exome-or-large-gene-panel-data#).

![](images/example_screenshot.png)

Alongside the different tiers (first 4 tabs) there are 3 addtional tabs:

  - **Mutation Assessor and Mutation Taster damaging:** A list of variants predicted as being potentially most damaging (Mutation Assessor High risk), including URL to variant information.
  - **Gene Ontology (GO) searching for a given gene/list of genes:** reports GO terms and links out to GO, UniProt and PubMed evidence (where present).
  - **Integrated Biodalliance Genome Viewer:** a reactive real-time genome track viewer capable of rendering bam and vcf files, as well as many other genomic tracks (including custom).

## Configure the `home` directory

This is the directory that contains all the results files (from [VCF-DART](https://github.com/sirselim/diagnostics_exome_reporting)) to be viewed. This must be set before runnin the VCF-Dart Viewer server.

The user is required to edit the appropriate line in the `global.R` file:

```R
# set directory to search for results files
HOMEDIR <- "/home/grcnata/"
addResourcePath("homeDir", HOMEDIR)
res.list <- list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T)
MutAssess.links <- list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T)
```

## To-do list / feature list

  - [ ] change repository name to refelct the new naming scheme (VCF-DART Viewer)
  - [x] ~~add ability to generate html links to NCBI for variants with RS numbers~~
  - [x] ~~add ability to generate html links out to GnomAD for each variant~~
  - [x] ~~investigate why the biomartr go function is taking so long~~
    + [x] ~~new method implemented, local database created and loaded in `global_load_data.RData`~~
    + [x] ~~include linkinig out to GO, UniProt and NCBI from this table~~
  - [ ] strange issue with newer VEP, adds '%3D' to syn ammino acid coding annotation, i.e. p.Pro1620%3D
    + [x] ~~added a quick fix to `server.R` to replace these values with `.`~~
    + [ ] investigate this further, might require an issue on VEP GitHub
  - [x] ~~investigate a bug where the file names don't reflect the correct sample when downloaded via the DT buttons~~
    + [x] ~~DT buttons aren't reactive, have removed sampleID from filename, user can define when downloading~~
  - [x] ~~fix issue with timestamp in filename when downloading data~~