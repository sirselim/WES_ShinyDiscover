
res.list <- list.files(path = 'results', pattern = '*clean.*..csv', include.dirs = T, recursive = T, full.names = T)
sample.list <- res.list[grep('DG1051', res.list)]
# # sample.list
#
# #
tier0.file <- sample.list[grep('Tier0', sample.list)]
tier0 <- read.csv(tier0.file, head = T, as.is = T)
# #
# tier1.file <- sample.list[grep('Tier1', sample.list)]
# tier1 <- read.csv(tier1.file, head = T, as.is = T)
# #
# tier2.file <- sample.list[grep('Tier2', sample.list)]
# tier2 <- read.csv(tier2.file, head = T, as.is = T)
# #
# tier3.file <- sample.list[grep('Tier3', sample.list)]
# tier3 <- read.csv(tier3.file, head = T, as.is = T)

# generate link list for mutation assessor files
MutAssess.links <- list.files(path = 'results/mutation_links', pattern = '.txt', include.dirs = T, recursive = T, full.names = T)
#
# MA.list <- MutAssess.links[grep('DG1051', MutAssess.links, fixed = T)]
# MA.table <- read.table(MA.list, head = T, as.is = T)

# get current day/date
file.time <- format(Sys.time(), "%a_%b_%d_%Y")
