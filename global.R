# required packages
# library("GenomicFeatures")
# library('Gviz')
# library('TxDb.Hsapiens.UCSC.hg19.knownGene')
# library('annmap')
library("biomaRt")
# get transcript data
# annmapConnect(use.webservice = T, name = 'homo_sapiens.74') #hg19
# get BioMart hg19 build
# ensembl54 <- useMart(biomart="ENSEMBL_MART_ENSEMBL", host="grch37.ensembl.org", path="/biomart/martservice", dataset="hsapiens_gene_ensembl")
# 
# #
# res.list <- list.files(path = 'results', pattern = '*clean.*..csv', include.dirs = T, recursive = T, full.names = T)
# sample.list <- res.list[grep('DG1051', res.list)]
# # # sample.list
# #
# # #
# tier0.file <- sample.list[grep('Tier0', sample.list)]
# tier0 <- read.csv(tier0.file, head = T, as.is = T)
# # #
# # tier1.file <- sample.list[grep('Tier1', sample.list)]
# # tier1 <- read.csv(tier1.file, head = T, as.is = T)
# # #
# # tier2.file <- sample.list[grep('Tier2', sample.list)]
# # tier2 <- read.csv(tier2.file, head = T, as.is = T)
# # #
# # tier3.file <- sample.list[grep('Tier3', sample.list)]
# # tier3 <- read.csv(tier3.file, head = T, as.is = T)
# 
# # generate link list for mutation assessor files
# MutAssess.links <- list.files(path = 'results/mutation_links', pattern = '.txt', include.dirs = T, recursive = T, full.names = T)
# #
# MA.list <- MutAssess.links[grep('DG1051', MutAssess.links, fixed = T)]
# MA.table <- read.table(MA.list, head = T, as.is = T)

# load pre saved global data to speed up app load time
load("global_load_data.RData")

# get current day/date
file.time <- format(Sys.time(), "%a_%b_%d_%Y")

# # bam file to search
# bam.dir <- '/media/disk1part1/PostDoc/Neven/bam/'
# bam.list <- list.files(bam.dir, pattern = '.bam$', full.names = T, include.dirs = T)
# bam.file <- bam.list[grep('DG1051', bam.list)]
# 
# # annmap is broken, using custom UCSC table
# ucsc.genes <- read.table('UCSC_wholegenes.bed', head = F, as.is = T)


