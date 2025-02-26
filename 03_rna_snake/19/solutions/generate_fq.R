#!/usr/bin/env R
setwd('~/biotech4neuro/material/19')
seqs <- read.table('droso.txt', comment.char="#", stringsAsFactors=FALSE)

n_reads <- 1000
n_samples <- 5

len_read <- unique(nchar(seqs$V1))
## Homework: reason on how to produce more 'reasonable' qualities (lower at the end of reads, higher before)?
qual_chars <- unlist(strsplit("!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI",""))

# first n_samples -1 samples with all reads randomly selected
for (i in seq(1, (n_samples-1))) {
  sample <- paste0("sample_", letters[i])
  fq_name <- paste0(sample, '.fastq.gz')
  fq <- gzfile(fq_name, open="w")
  for (r in seq(1, n_reads)) {
    qual <- paste(qual_chars[sample.int(length(qual_chars), len_read, replace=TRUE)], collapse="")
    entry <- c(paste0('@',r), seqs[sample.int(nrow(seqs),1),1], '+', qual)
    writeLines(entry, fq)
  }
  close(fq)
}

# last sample express only one gene (first 7 lines of droso.txt)
seqs <- seqs[seq(1,7),, drop=FALSE]
i <- 5
sample <- paste0("sample_", letters[i])
fq_name <- paste0(sample, '.fastq.gz')
fq <- gzfile(fq_name, open="w")
for (r in seq(1, n_reads)) {
  qual <- paste(qual_chars[sample.int(length(qual_chars), len_read, replace=TRUE)], collapse="")
  entry <- c(paste0('@',r), seqs[sample.int(nrow(seqs),1),1], '+', qual)
  writeLines(entry, fq)
}
close(fq)

