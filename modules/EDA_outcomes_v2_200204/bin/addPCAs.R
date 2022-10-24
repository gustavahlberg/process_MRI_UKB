#
#
#  Add new pca's from flashPCA model
#
# ---------------------------------------------
#
# load tabel
#


newpca = read.table("../fastPpca_200220/results/ukbMriSubset.FlashPca.txt",
                    stringsAsFactors = F,
                    header = T)


loadings = read.table("../fastPpca_200220/results/loadings.txt",
                    stringsAsFactors = F,
                    header = T)




dim(newpca); dim(snptestDF)
all(newpca$IID %in% snptestDF$ID_1 )
rownames(newpca) <- as.character(newpca$FID)



# ---------------------------------------------
#
# add
#

newpca = newpca[as.character(snptestDF$ID_1),]
all(newpca$FID == snptestDF$ID_1)
idxNA = which(is.na(snptestDF$PC1))

plot(snptestDF$PC1[-idxNA],snptestDF$PC2[-idxNA])
plot(newpca$PC1[-idxNA],newpca$PC2[-idxNA])



snptestDF[,paste0("PC",1:10)] <- newpca[,paste0("PC",1:10)]



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################





