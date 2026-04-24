library(mixOmics)
# /mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/multiclass/only450k/0.01_beta_selected_450k_2023_k5_transposed-wClusters-noSilho.tsv.gz 

#egrassi@godot:/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/minfi$ zcat /mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/multiclass/only450k/0.01_beta_selected_450k_2023_k5_transposed-wClusters-noSilho.tsv.gz | head -n1 |tr "\t" "\n"| grep cg > /tmp/cgSel
#egrassi@godot:/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/minfi$ wc -l /tmp/cgSel 
#5494 /tmp/cgSel
#egrassi@godot:/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/TCGA/minfi$ zcat TCGA_m_values_2023_v2.tsv.gz | sed 1d | cut -f 1  | filter_1col 1 /tmp/cgSel  > /tmp/cgSel_TCGA


# define list of cg from here common with TCGA:
# /mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/TCGA/minfi/TCGA_m_values_2023_v2.tsv.gz  

#/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/minfi/m_values_final_2023.tsv.gz

# subset M values

# Ok Marco li ha già!

tcga_f <- '/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/TCGA/TCGA_m_selected_onBeta_2023_v2.tsv.gz'
# TODO recuperare TCGA expression
methy_f <- '/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/cluval/0.01_m_selected_onBeta_2023.tsv.gz'
# subset only to LMX with expression values (and subset expression too)

expr_f <- '/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v2/misc/LMX_BASALE_mean_gene_genealogy-MethylSamples.tsv.gz'
methy_f <- '/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/cluval/0.01_m_selected_onBeta_2023.tsv.gz'

expr <- read.table(gzfile(expr_f), sep="\t", header=T, row.names=1)
methy <- read.table(gzfile(methy_f), sep="\t", header=T, row.names=1)

methy <- methy[, grepl('LMX', colnames(methy))]

expr <- t(expr)
methy <- t(methy)
rownames(methy) <- substr(rownames(methy), 0, 7)

#length(rownames(methy))
#length(unique(rownames(methy)))
#length(unique(rownames(expr)))
#length(rownames(expr))

models <- intersect(rownames(methy), rownames(expr))

## select top sd to have a small example

sds <- apply(methy, 2, sd)
osds <- order(sds)
methy <- methy[, osds]
methy <- methy[, seq(1, 200)]

sel_p_methy <- colnames(methy)

protcoding <- read.table('/mnt/trcanmed/snaketree/stash/tss_default.bed', sep="\t", header=F, stringsAsFactors = F)
expr <- expr[, colnames(expr) %in% paste0('H_', protcoding$V4)]
exprave <- colMeans(expr)
expr <- expr[, exprave > median(exprave)]
sds <- apply(expr, 2, sd) # not the best selection add expression min TODO
osds <- order(-sds)
expr <- expr[, osds]
expr <- expr[, seq(1, 200)]

sel_g_expr <- colnames(expr)
######################
expr <- expr[, wg]
methy <- methy[, wp]
######################
test_n <- 65
set.seed(42)
test <- sample(models, size=65)
train <- setdiff(models, test)

methy_tr <- methy[train,]
expr_tr <- expr[train,]

methy_te <- methy[test,]
expr_te <- expr[test,]

# scale
methy_tr <- as.data.frame(scale(methy_tr))
expr_tr <- as.data.frame(scale(expr_tr))
methy_te <- as.data.frame(scale(methy_te))
expr_te <- as.data.frame(scale(expr_te))

# prediction - Y
methy_cl <- read.table('/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/cluval/NMF/PDXs-2023/samples_clusters_k5_ordered_2023.tsv', sep="\t", header=F)
colnames(methy_cl) <- c('sample', 'cluster')
methy_cl <- methy_cl[grepl('LMX', methy_cl$sample),]
rownames(methy_cl) <- methy_cl$sample
methy_cl$sample <- NULL

### For now predict only 1 vs other
####methy_cl$cluster <- ifelse(methy_cl$cluster == 1, 'CIMP', 'nonCIMP')

methy_cl_te <- methy_cl[test, , drop=F]
methy_cl_tr <- methy_cl[train, , drop=F]

data <- list(methy = methy_tr,
            mRNA = expr_tr)
Y <- as.factor(methy_cl_tr$cluster) # set the response variable as the Y df

# prelim analysis
list.keepX <- c(25, 25) # select arbitrary values of features to keep
list.keepY <- c(25, 25)

# generate three pairwise PLS models
pls1 <- spls(data[["methy"]], data[["mRNA"]], 
             keepX = list.keepX, keepY = list.keepY) 

# plot features of first PLS
# cutoff = 0 selection dei geni fatta a cazzo? (sì era sd ordinata al contrario)
p <- plotVar(pls1, cutoff = 0.5, title = "(a) miRNA vs mRNA", 
             legend = c("methy", "mRNA"), 
             var.names = FALSE, style = 'graphics', 
             pch = c(16, 17), cex = c(2,2), 
             col = c('darkorchid', 'lightgreen'))
# già si potrebbe discutere un po' di struttura, < 10' su ulisse

design <- matrix(0.1, ncol = length(data), nrow = length(data), 
                dimnames = list(names(data), names(data)))
diag(design) <- 0 # set diagonal to 0s
# null would be all 0, full all 1 with 0 on diag

#An arbitrarily high number of components (ncomp = 5)  ? # TODO put back 5 for CIMP - nonCIMP
basic.diablo.model <- block.splsda(X = data, Y = Y, ncomp = 8, design = design) 

plot(basic.diablo.model)
# run component number tuning with repeated CV # lunghetto su questi dati - reduce n repeat?
perf.diablo = perf(basic.diablo.model, validation = 'Mfold', 
                   folds = 10, nrepeat = 5, progressBar=TRUE) 

plot(perf.diablo) # plot output of tuning
## think _well_ about what's happening here

ncomp = perf.diablo$choice.ncomp$WeightedVote["Overall.BER", "centroids.dist"] 
# show the optimal choice for ncomp for each dist metric
perf.diablo$choice.ncomp$WeightedVote 

# set grid of values for each component to test # TODO reduce here if too slow
test.keepX = list (methy = c(5:9, seq(10,30,5)), 
                   mRNA = c(5:9, seq(10,30,5)))

tune.TCGA = tune.block.splsda(X = data, Y = Y, ncomp = ncomp, 
                              test.keepX = test.keepX, design = design,
                              validation = 'Mfold', folds = 10, nrepeat = 1,
                              dist = "centroids.dist", progressBar=TRUE) # 16:20 - 16:28

list.keepX = tune.TCGA$choice.keepX # set the optimal values of features to retain on each component
list.keepX

final.diablo.model = block.splsda(X = data, Y = Y, ncomp = ncomp, 
                                  keepX = list.keepX, design = design)

# discuss: all 1 vs Y for prediction.
#final.diablo.model$design # design matrix for the final model


selectVar(final.diablo.model, block = 'mRNA', comp = 1)$mRNA$name 

plotDiablo(final.diablo.model, ncomp = 1) # TODO n comp = 2 # discusso how comp2 does not distinguish Basal and LumA

plotIndiv(final.diablo.model, ind.names = FALSE, legend = TRUE, 
          title = 'DIABLO Sample Plots')

# mh
#plotArrow(final.diablo.model, ind.names = FALSE, legend = TRUE, 
#title = 'DIABLO')

data.test.TCGA = list(methy = methy_te, mRNA = expr_te)

predict.diablo = predict(final.diablo.model, newdata = data.test.TCGA)

confusion.mat = get.confusion_matrix(truth = as.factor(methy_cl_te$cluster),
                                     predicted = predict.diablo$WeightedVote$centroids.dist[,ncomp]) 

get.BER(confusion.mat)

cimDiablo(final.diablo.model)


### TCGA
tcga_methy_f <- '/mnt/trcanmed/snaketree/prj/pdx_methylation/dataset/v4/TCGA/TCGA_m_selected_onBeta_2023_v2.tsv.gz'
tcga_expr_f <- '/mnt/trcanmed/snaketree/stash/TCGA-COAD.star_tpm_gs.tsv.gz'

expr_t <- read.table(gzfile(tcga_expr_f), sep="\t", header=T, row.names=1)
methy_t <- read.table(gzfile(tcga_methy_f), sep="\t", header=T, row.names=1)

expr_t <- expr_t[!grepl(',',expr_t$description),]

df <- as.data.frame(table(expr_t$description))
expr_t <- expr_t[expr_t$description %in% df[df$Freq==1, 'Var1'],]
rownames(expr_t) <- expr_t$description
expr_t$description <- NULL

expr_t <- t(expr_t)
methy_t <- t(methy_t)

w <- intersect(rownames(expr_t), rownames(methy_t))
expr_t <- expr_t[w,]
methy_t <- methy_t[w,]

colnames(expr_t) <- paste0('H_', colnames(expr_t))

expr_t <- expr_t[,colnames(expr_t) %in% sel_g_expr]
methy_t <- methy_t[,colnames(methy_t) %in% sel_p_methy]

methy_t <- as.data.frame(scale(methy_t))
expr_t <- as.data.frame(scale(expr_t))

data.test.TCGA = list(methy = methy_t, mRNA = expr_t)

predict.diablo = predict(final.diablo.model, newdata = data.test.TCGA)

#confusion.mat = get.confusion_matrix(truth = as.factor(methy_cl_te$cluster),
#                                     predicted = predict.diablo$WeightedVote$centroids.dist[,ncomp]) 

table(predict.diablo$WeightedVote$centroids.dist[,ncomp])

pls1 <- spls(data.test.TCGA[["methy"]], data.test.TCGA[["mRNA"]], 
             keepX = list.keepX, keepY = list.keepY) 

# plot features of first PLS
list.keepX <- c(25, 25) # select arbitrary values of features to keep
list.keepY <- c(25, 25)

p <- plotVar(pls1, cutoff = 0.5, title = "(a) miRNA vs mRNA", 
             legend = c("methy", "mRNA"), 
             var.names = FALSE, style = 'graphics', 
             pch = c(16, 17), cex = c(2,2), 
             col = c('darkorchid', 'lightgreen'))

wg <- colnames(expr_t)
wp <- colnames(methy_t)
saveRDS(wp, file="~/selected_common_diablo.rds")

write.table(predict.diablo$WeightedVote$centroids.dist, sep="\t", file="~/TCGA_diablo.tsv", quote=F)
