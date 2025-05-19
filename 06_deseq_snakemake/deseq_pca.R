library(DESeq2)

vsd_f <- snakemake@input[['vsd']]
plot_f <- snakemake@output[['plot']]
intgroup <- snakemake@wildcards[['ss_col']]


vsd <- readRDS(vsd_f)
png(plot_f)
plotPCA(vsd, intgroup=intgroup)
graphics.off()