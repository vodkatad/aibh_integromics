input <- snakemake@input # this is a list of counts.tsv
output <- snakemake@output[['counts']]
# input[[1]] will be "sample_a_counts.tsv"

# the idea is to loop on all files in input and merge them sequentially using Geneid.
# from counts tsv we keep only column 1 and 7 (GeneId and counts for our samples)
for (i in seq(1, length(input))) {
    if (i == 1) { # during the first round of the loop we do not have anything to merge
        merged_counts <- read.table(input[[i]], sep="\t", comment.char="#", header=TRUE, quote="")
        merged_counts <- merged_counts[,c(1,7)]
    }   else { # in the others yes
        counts <- read.table(input[[i]], sep="\t", comment.char="#", header=TRUE, quote="")
        counts <- counts[,c(1,7)]
        merged_counts <- merge(merged_counts, counts, by="Geneid")
    }
}

write.table(merged_counts, file=output, sep="\t", quote=FALSE, row.names = FALSE)