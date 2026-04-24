library(ggplot2)

n_reads_f <- snakemake@input[['n']]
outputplot <- snakemake@output[['plot']]

n_reads <- read.table(n_reads_f, header=FALSE)

p <- ggplot(data=n_reads, aes(x=V1))+geom_histogram()+theme_bw(base_size=20)+xlab('N reads')

ggsave(p, file=outputplot)