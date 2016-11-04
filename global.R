
res.list <- list.files(path = 'results', pattern = '*clean.*..csv', include.dirs = T, recursive = T, full.names = T)
sample.list <- res.list[grep('DG906', res.list)]
# # sample.list
# 
# #
tier0.file <- sample.list[grep('Tier0', sample.list)]
tier0 <- read.csv(tier0.file, head = T, as.is = T)

# generate link list for mutation assessor files
MutAssess.links <- list.files(path = 'results/mutation_links', pattern = '.txt', include.dirs = T, recursive = T, full.names = T)

