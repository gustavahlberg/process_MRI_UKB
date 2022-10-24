# 
#
# ventricular volumes
#
# ---------------------------------------------
#
# load data
# 


vvtab = read.table("../../modules/analyseImages_191107/results/table_ventricular_volume_all.csv",
                   header = T,
                   stringsAsFactors = F,
                   sep = ",")
vvtab = vvtab[-which(duplicated(vvtab)),]

head(vvtab)
rownames(vvtab) <- as.character(vvtab$X)
vvtab <- vvtab[,1:5]


# ---------------------------------------------
#
# add left ventricular measurments
# 


voltab$LVEF = vvtab[voltab$sample.id,]$LVEF....
voltab$LVEDV = vvtab[voltab$sample.id,]$LVEDV..mL.
voltab$LVESV = vvtab[voltab$sample.id,]$LVESV..mL.
voltab$LVSV = vvtab[voltab$sample.id,]$LVSV..mL.


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################


