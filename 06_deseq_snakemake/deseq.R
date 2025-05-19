library(DESeq2)

counts_f <- snakemake@input[['counts']]
gene_len_f <- snakemake@input[['gene_len']]
ss_f <- snakemake@input[['sample_sheet']]
deseq_rds_f <- snakemake@output[['deo']]
fpkm_f <- snakemake@output[['fpkm']]
vsd_f <- snakemake@output[['vsdo']]
log <- snakemake@log[['log']]

count_data <- read.table(gzfile(counts_f), header=TRUE, sep="\t", row.names=1)
n1 <- nrow(count_data)
minc <- 10
minsamples <- 5
efilterGenes <- rowSums(count_data > minc) < minsamples
n2 <- nrow(count_data[!efilterGenes,])

sink(log)
"Filtering info:"
n1
n2
sink()

sample_sheet <- read.table(ss_f, sep="\t", row.names=1)

# build the formula from sample sheet colnames
fdesign <- as.formula(paste0("~", paste0(colnames(sample_sheet), collapse='+')))

dds <- DESeqDataSetFromMatrix(countData = count_data, colData = sample_sheet, design = fdesign)
dds <- dds[!efilterGenes] 
dds <- DESeq(dds, parallel=TRUE, betaPrior=TRUE) 
vsd <- vst(dds, blind=FALSE) 

saveRDS(vsd, file=vsd_f)
saveRDS(dds, file=deseq_rds_f)

lens <- read.table(gene_len_f, sep="\t", header=TRUE)
order <- rownames(mcols(dds))
lens <- lens[lens$Geneid %in% order,]
lens <- lens[match(order, lens$Geneid), ]
mcols(dds)$basepairs  <- lens$length
fpkm_d <- fpkm(dds, robust=TRUE)

write.table(fpkm_d, file=gzfile(fpkm_f), sep="\t", quote=FALSE, row.names=TRUE, col.names=TRUE)

