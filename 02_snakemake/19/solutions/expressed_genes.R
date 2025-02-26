input <- snakemake@input[['counts']]
output <- snakemake@output[['expr_counts']]

counts <- read.table(input, sep="\t", header=TRUE, row.names=1, quote="")
allcounts <- apply(counts, 1, sum)

expressed_counts <- counts[allcounts != 0,]
        
write.table(expressed_counts, file=output, sep="\t", quote=FALSE, row.names = TRUE)