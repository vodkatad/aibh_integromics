input <- snakemake@input[['counts']]
map <- snakemake@input[['map']]
output <- snakemake@output[['ense_counts']]

counts <- read.table(input, sep="\t", header=TRUE, row.names=1, quote="")
mapdf <- read.table(map, sep="\t", header=TRUE)


ens_counts <- merge(counts, mapdf, by.x="row.names", by.y="GeneName")


write.table(ens_counts, file=output, sep="\t", quote=FALSE, row.names = FALSE)