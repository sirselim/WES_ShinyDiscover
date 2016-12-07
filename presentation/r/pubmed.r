#install.packages("RISmed")
library(RISmed)
search_topic <- 'reproducible research'

rr.pubmed <- NULL
rr.data <- for (i in 1:65){
    mindate=1950+i
    maxdate=1950+i+1
    search_query <-EUtilsSummary(search_topic, mindate=mindate, maxdate=maxdate)
    rr.pubmed <- rbind(rr.pubmed, (c(mindate, search_query@count)))}
