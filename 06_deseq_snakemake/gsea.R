library(clusterProfiler)
library(msigdb)
library(enrichplot)
library(ggplot2)

deg_f <- snakemake@input[['deg']]
genesets_f <- snakemake@input[['genesets']]
plot_f <- snakemake@output[['gseaplot']]
gsea_f <- snakemake@output[['gsea']]

resnona <- read.table(deg_f, sep="\t", row.names=1)

geneList <- resnona$log2FoldChange
names(geneList) <- rownames(resnona)
geneList <- sort(geneList, decreasing = TRUE)

h_t2g <- readRDS(genesets_f)

gsea_h <-  GSEA(geneList, TERM2GENE=h_t2g, pvalueCutoff = 1, nPermSimple = 1000)
write.table(gsea_h@result, file=gsea_f, sep="\t", quote=FALSE)
png(plot_f)
ridgeplot(gsea_h, showCategory = 20)+theme_bw(base_size=10)
graphics.off()