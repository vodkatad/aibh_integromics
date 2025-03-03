library(mixOmics)
set.seed(123)
data(breast.TCGA) # load in the data

# list of matrices with samples on rows and features on columns
data = list(miRNA = breast.TCGA$data.train$mirna, 
            mRNA = breast.TCGA$data.train$mrna,
            proteomics = breast.TCGA$data.train$protein)
Y = breast.TCGA$data.train$subtype # set the response variable as the Y df

# prelim analysis
list.keepX = c(25, 25) # select arbitrary values of features to keep
list.keepY = c(25, 25)

# generate three pairwise PLS models
pls1 <- spls(data[["miRNA"]], data[["mRNA"]], 
             keepX = list.keepX, keepY = list.keepY) 

# plot features of first PLS
p <- plotVar(pls1, cutoff = 0.5, title = "(a) miRNA vs mRNA", 
        legend = c("miRNA", "mRNA"), 
        var.names = FALSE, style = 'graphics', 
        pch = c(16, 17), cex = c(2,2), 
        col = c('darkorchid', 'lightgreen'))


head(pls1$variates$X)
head(pls1$variates$Y)
plot(pls1$variates$X, pls1$variates$Y)

#> head(p)
#x           y Block names pch cex        col font           Overlap
#hsa-let-7c      0.06997021  0.45540324 miRNA    16  16   2 darkorchid    1 (a) miRNA vs mRNA

# plotVar plots the correlation between each feature (eg.mirna expr) and the selected components
#
#
#> cor(mi, pls1$variates$X[,2])
#[1] 0.4554032
#> cor(mi, pls1$variates$X[,1])
#[1] 0.06997021

# high correlation would suggest 0.8-0.9 but now we prefer good predictions so 0.1
design = matrix(0.1, ncol = length(data), nrow = length(data), 
dimnames = list(names(data), names(data)))
diag(design) = 0 # set diagonal to 0s
# null would be all 0, full all 1 with 0 on diag

#An arbitrarily high number of components (ncomp = 5)  ?
basic.diablo.model = block.splsda(X = data, Y = Y, ncomp = 5, design = design) 


# run component number tuning with repeated CV # not immediate
perf.diablo = perf(basic.diablo.model, validation = 'Mfold', 
                   folds = 10, nrepeat = 10) 

plot(perf.diablo) # plot output of tuning
## think _well_ about what's happening here


# set the optimal ncomp value
ncomp = perf.diablo$choice.ncomp$WeightedVote["Overall.BER", "centroids.dist"] 
# show the optimal choice for ncomp for each dist metric
perf.diablo$choice.ncomp$WeightedVote 

# set grid of values for each component to test # TODO reduce here if too slow
test.keepX = list (mRNA = c(5:9, seq(10, 18, 2), seq(20,30,5)), 
                   miRNA = c(5:9, seq(10, 18, 2), seq(20,30,5)),
                   proteomics = c(5:9, seq(10, 18, 2), seq(20,30,5)))

# run the feature selection tuning # Log - BPPARAM  20'on ulisse with 1 core
tune.TCGA = tune.block.splsda(X = data, Y = Y, ncomp = ncomp, 
                              test.keepX = test.keepX, design = design,
                              validation = 'Mfold', folds = 10, nrepeat = 1,
                              dist = "centroids.dist")

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

circosPlot(final.diablo.model, cutoff = 0.7, line = TRUE,
           color.blocks= c('darkorchid', 'brown1', 'lightgreen'),
           color.cor = c("chocolate3","grey20"), size.labels = 1.5)
# brutto forte su ulisse

# plotLoadings(final.diablo.model, comp = 2, contrib = 'max', method = 'median')

# cimDiablo(final.diablo.model)
### skipped performance
# external test set
data.test.TCGA = list(mRNA = breast.TCGA$data.test$mrna, miRNA = breast.TCGA$data.test$mirna)

predict.diablo = predict(final.diablo.model, newdata = data.test.TCGA)

# why 2? 2 component model
confusion.mat = get.confusion_matrix(truth = breast.TCGA$data.test$subtype,
                                     predicted = predict.diablo$WeightedVote$centroids.dist[,2])

get.BER(confusion.mat)