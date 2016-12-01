# required packages
library("GenomicFeatures")
library('Gviz')
library('TxDb.Hsapiens.UCSC.hg19.knownGene')
library('annmap')
library("biomaRt")
# get transcript data
annmapConnect(use.webservice = T, name = 'homo_sapiens.74') #hg19
# get BioMart hg19 build
ensembl54=useMart(biomart="ENSEMBL_MART_ENSEMBL", host="grch37.ensembl.org", path="/biomart/martservice", dataset="hsapiens_gene_ensembl")
# get info for a single gene by hgnc symbol
gene.search <- getBM(attributes = c("hgnc_symbol","entrezgene", "chromosome_name", "start_position", "end_position"), 
                 filters = c("hgnc_symbol"), values = 'FTO', mart = ensembl54)
gene.search$chromosome_name <- paste0('chr', gene.search$chromosome_name)

# bam file to search
bam.dir <- '/media/disk1part1/PostDoc/Neven/bam'
bam.list <- list.files(bam.dir, pattern = '.bam$', full.names = T, include.dirs = T)
bam.file <- bam.list[grep('DG1051', bam.list)]
# asign bam file and prepare coverage and alignment tracks
alTrack=AlignmentsTrack(bam.file, isPaired=F) #Read bam file
# create gtrack
gtrack <- GenomeAxisTrack()
# create dtrack
dtrack <- DataTrack(range=bam.file, genome="hg19", name="Coverage", chromosome=gene.search$chromosome_name,
                    type = "histogram", col.histogram= "#377EB8", fill="#377EB8")
# create ideogram track
itrack <- IdeogramTrack(genome="hg19", chromosome=gene.search$chromosome_name) #requires internet connection
# create transcript track
grtrack <- GeneRegionTrack(TxDb.Hsapiens.UCSC.hg19.knownGene, genome = "hg19", chromosome=gene.search$chromosome_name, 
                           name="TxDb.Hsapiens.UCSC.hg19")
# get transcript info for selected gene
gene = symbolToGene(gene.search$hgnc_symbol)
transcript.out <- geneToTranscript(gene)
tran.start <- transcript.out@ranges@start[1]
tran.end <- data.frame(transcript.out@ranges[length(transcript.out)])[[2]]
# create plot
plotTracks(list(itrack, gtrack, grtrack, alTrack), from = tran.start, to = tran.end)