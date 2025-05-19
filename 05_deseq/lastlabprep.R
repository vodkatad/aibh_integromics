counts_f <- '/home/stud0/aibh_integromics/05_deseq/data/counts_HXO.tsv.gz'
count_data <- read.table(gzfile(counts_f), header=TRUE, sep="\t", row=1)
sample_sheet <- data.frame(row.names=colnames(count_data),
class=ifelse(grepl('LMH', colnames(count_data)), 'human', ifelse(grepl('LMO', colnames(count_data)), 'organoid', 'xeno')),  model=substr(colnames(count_data), 0, 7))
write.table(sample_sheet, file='/home/stud0/aibh_integromics/05_deseq/data/samplesheet.tsv', sep="\t", quote=F, row.names = T, col.names = T)
