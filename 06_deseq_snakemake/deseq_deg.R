library(DESeq2)
library(ggplot2)
library(ggrepel)

deseq_rds_f <- snakemake@input[['deo']]
volcano_f <- snakemake@output[['volcano']]
deg_f <- snakemake@output[['deg']]
col <- snakemake@wildcards[['ss_col']]
nom <- snakemake@wildcards[['nom']]
den <- snakemake@wildcards[['den']]

dds <- readRDS(deseq_rds_f)

lfc <- 0.58
alpha <- 0.05
res <- results(dds, alpha=alpha, contrast=c(col, nom, den))
resnona <- as.data.frame(res[!is.na(res$pvalue) & !is.na(res$padj),])
resnona$sign <- ifelse(abs(resnona$log2FoldChange) > lfc & resnona$padj < alpha, "both", 
                       ifelse(abs(resnona$log2FoldChange) > lfc, "LFC", ifelse(resnona$padj < alpha, "padj", "NS")))
resnona$sign <- factor(resnona$sign, levels=c("LFC", "padj", "both", "NS"))
if (any(resnona$padj == 0)) {
  resnona[resnona$padj == 0, "padj"] <- .Machine$double.xmin
}
p <- ggplot(resnona, aes(log2FoldChange, -log10(padj))) +
  geom_point(aes(col = sign),size=0.5) + theme_bw() +
  scale_color_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#999999"), drop=FALSE) +
  ggtitle(paste0('Volcano Plot ', nom, ' vs ', den))
nsign <- nrow(resnona[resnona$sig=="both",])
resnona <- resnona[order(resnona$padj),]
if (nsign > 10) {
  p <- p + geom_text_repel(data=resnona[1:10,], aes(label=rownames(resnona)[1:10]))
} else {
  p <- p + geom_text_repel(data=resnona[resnona$sig=="both",], aes(label=rownames(resnona[resnona$sig=="both",])))
}

ggsave(volcano_f, plot=p)

write.table(resnona, file=deg_f, sep="\t", row.names=TRUE, col.names=TRUE, quote=FALSE)