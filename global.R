## global.R for VCF-DART Viewer
# required packages
require(GO.db)  ## NOTE: need to ensure this is installed on taurus (and add package depends to GitHub)

# load pre saved global data to speed up app load time
load("global_load_data.RData")

# define GO terms
goterms = unlist(Term(GOTERM))

# set directory to search for results files
HOMEDIR <- "/home/grcnata"
#HOMEDIR <- "."
addResourcePath("homeDir", HOMEDIR)
res.list <- list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T)
MutAssess.links <- list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T)

# create 'dummy' global variable to set current day/date timestamp
file.time <- ""

## define functions to use throughout server script
# create an html button linking out to Mutation Assessor which can be rendered in Shiny (by DT)
createLink <- function(val) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">Link to Variant</a>', val)
}
# create an html link to NCBI for SNPs which can be rendered in Shiny (by DT)
createSNPLink <- function(val) {
  # if there are mutiple snps split and unlist them
  val <- unlist(strsplit(val, split = ';'))
  snp <- NULL
  # loop through multiple snps if present
  for (i in val) {
    # check if there is no snp ID, make NA if so
    if (i == ".") {
      snp <- "NA"
      # else create html links for each snp present
    } else {
      snp <- paste(snp, 
                   sprintf(paste0('<a href="https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=%s" target="_blank">', i, '</a>'), i), 
                   sep = ';')
    }
  }
  # clean up leading ';' if present
  snp <- gsub('^;<', '<', snp)
}

# creating links to GnomAD
# example: "http://gnomad.broadinstitute.org/variant/17-10215944-G-A"
createGnomADLink <- function(tierData) {
  # define variant search data
  chr <- unlist(lapply(strsplit(tierData$location, split = ':'), '[[', 1)) %>% gsub('chr', '', .)
  position <- unlist(lapply(strsplit(tierData$location, split = ':'), '[[', 2))
  ref_geno <- tierData$ref
  alt_geno <- tierData$alt
  # make search term
  gnomad <- paste(chr, position, ref_geno, alt_geno, sep = '-')
  # create link
  sprintf('<a href="http://gnomad.broadinstitute.org/variant/%s" target="_blank" class="btn btn-primary">GnomAD Link</a>', gnomad)
}

# GO link
createGOLink <- function(goterm) {
  sprintf(paste0('<a href="http://amigo.geneontology.org/amigo/term/%s" target="_blank">', goterm, '</a>'), goterm)
}

# UniProt link
createUniProtLink <- function(uniprot) {
  sprintf(paste0('<a href="http://www.uniprot.org/uniprot/%s" target="_blank">', uniprot, '</a>'), uniprot)
}

# PUBMED link
createPMIDLink <- function(pmid) {
  sprintf(paste0('<a href="https://www.ncbi.nlm.nih.gov/pubmed/%s" target="_blank">', pmid, '</a>'), pmid)
}
##/END