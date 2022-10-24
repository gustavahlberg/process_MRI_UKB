#
#
# 
#  create table for snptest 
#
# ---------------------------------------------
#
# check
#


ttnvar = read.table(file = "../../data/ttnvar.raw",
                    header = T,
                    stringsAsFactors = F)
all(sample.eth.id == ttnvar$IID)
all(sample.eth.id %in% ttnvar$IID)

bgen.sample = read.table(file = "../../data/ukbCMR.ordered.etn_200219.sample",
                         header = T,
                         stringsAsFactors = F)

all(bgen.sample$ID_1[-1] ==  ttnvar$IID)


# ---------------------------------------------
#
# 
# df skeleton
#

dim(voltab)
colnames(voltab)
head(voltab)

colnames(voltab)[grep("la",colnames(voltab))]
snptestDF = data.frame(ID_1 = bgen.sample$ID_1[-1],
                       ID_2 = bgen.sample$ID_1[-1],
                       missing = 0,
                       sex = bgen.sample$sex[-1],
                       genotyping.array = 0,
                       imgCenter = 0,
                       PC1 = NA,
                       PC2 = NA,
                       PC3 = NA,
                       PC4 = NA,
                       PC5 = NA,
                       PC6 = NA,
                       PC7 = NA,
                       PC8 = NA,
                       PC9 = NA,
                       PC10 = NA,
                       age = NA,
                       height = NA,
                       weight = NA,
                       bmi = NA,
                       bsa = NA,
                       bsa.2 = NA,
                       dbp = NA,
                       sbp = NA,
                       HR = NA,
                       pulseRate = NA,
                       stroke = NA,
                       svdAllCogVar = NA,
                       svdTrailCog = NA,
                       af = NA,
                       cm = NA,
                       hf = NA,
                       hf_cm = NA,
                       mi = NA,
                       LVEF=NA,
                       LVEDV=NA,
                       LVESV=NA,
                       LVSV=NA,
                       lamax= NA,
                       lamin= NA, 
                       lamdv = NA, 
                       labac=NA, 
                       lasv=NA,  
                       laev =NA,
                       lapev = NA,
                       latef = NA, 
                       lapef = NA, 
                       laaef =NA,
                       lape_svd = NA,
                       expansionidx = NA,
                       aeTangent = NA,
                       peTangent = NA,
                       ilamax= NA,
                       ilamin= NA, 
                       ilamdv = NA, 
                       ilabac=NA, 
                       ilasv=NA,  
                       ilaev =NA,
                       ilapev =NA,
                       rntrn_lamax= NA,
                       rntrn_lamin= NA, 
                       rntrn_lamdv = NA, 
                       rntrn_labac=NA, 
                       rntrn_lasv=NA,  
                       rntrn_laev =NA,
                       rntrn_lapev = NA,
                       rntrn_latef = NA, 
                       rntrn_lapef = NA, 
                       rntrn_laaef =NA,
                       rntrn_expansionidx =NA,
                       rntrn_aeTangent =NA,
                       rntrn_peTangent =NA,
                       rntrn_lape_svd = NA,
                       rntrn_ilamax=NA,
                       rntrn_ilamin=NA, 
                       rntrn_ilamdv =NA, 
                       rntrn_ilabac=NA, 
                       rntrn_ilasv=NA,  
                       rntrn_ilaev =NA,
                       rntrn_ilapev=NA,
                       rntrnBSA_lamax =NA,
                       rntrnBSA_lamin= NA,
                       rntrnBSA_lamdv=NA, 
                       rntrnBSA_labac=NA,
                       rntrnBSA_lasv=NA,
                       rntrnBSA_laev=NA,
                       rntrnBSA_lapev=NA,
                       rntrnBSA_latef=NA,
                       rntrnBSA_lapef=NA,
                       rntrnBSA_laaef=NA,
                       rntrnBSA_expansionidx =NA,
                       rntrnBSA_aeTangent =NA,
                       rntrnBSA_peTangent =NA,
                       rntrnBSA_lape_svd = NA,
                       stringsAsFactors = F
)

dim(snptestDF)
colnames(voltab)[!colnames(voltab) %in% colnames(snptestDF)]

# ---------------------------------------------
#
# match voltab w/ df
#

exclSamples = as.character(snptestDF$ID_1[!snptestDF$ID_1 %in% voltab$sample.id])

tmpTab = data.frame(matrix(data =  NA ,
                           nrow = length(exclSamples),
                           ncol = dim(voltab)[2]),
                    stringsAsFactors = F)

colnames(tmpTab) = colnames(voltab)
if(any(voltab$genotyping.array  == "UKBB")) {
  voltab$genotyping.array = ifelse(voltab$genotyping.array  == "UKBB",0,1)
}


tmpTab$sample.id = exclSamples
dim(rbind(voltab,tmpTab))[1] == nrow(snptestDF)
tmpTab = rbind(voltab,tmpTab)

all(tmpTab$sample.id %in% snptestDF$ID_1) 
all(snptestDF$ID_1 %in% tmpTab$sample.id)
all(tmpTab$sample.id[match(snptestDF$ID_1,tmpTab$sample.id)] == snptestDF$ID_1)
tmpTab = tmpTab[match(snptestDF$ID_1, tmpTab$sample.id),]

idx = which(colnames(snptestDF) %in%  c("ID_1","ID_2","missing"))

snptestDF$ID_2 <- tmpTab$sample.id
all(snptestDF$ID_2 == snptestDF$ID_1)

colnames(snptestDF[,-idx]) == colnames(tmpTab[,-1])
all(colnames(snptestDF[,-idx]) == colnames(tmpTab[,colnames(snptestDF[,-idx])]))
all(snptestDF$ID_1 == tmpTab$sample.id)

idx = which(colnames(snptestDF) %in%  c("ID_1","ID_2","sex","missing"))
snptestDF[,-idx] = tmpTab[,colnames(snptestDF[,-idx])]


#sanity check
tmp = snptestDF$LVEF
summary(lm(tmp ~ ttnvar$rs2042995_C+ snptestDF$sex + snptestDF$age + 
             snptestDF$bsa + snptestDF$imgCenter ))
summary(lm(snptestDF$lapef ~ snptestDF$sex + snptestDF$age + ttnvar$rs2042995_C +
             snptestDF$bsa + snptestDF$imgCenter ))
colnames(snptestDF[,-idx])[!colnames(snptestDF[,-idx]) %in% colnames(tmpTab)]


# type line
colnames(snptestDF)
typeLine = c(0,0,0,"D","D","D",rep("C",20),"D",rep("C",2),rep("D",5), rep("P",60))
length(typeLine); length(colnames(snptestDF))
names(typeLine) = colnames(snptestDF)

names(typeLine) = gsub("\\.$","",gsub("\\.\\.","\\.",names(typeLine)))
names(typeLine) = gsub("\\.$","",names(typeLine))


# ---------------------------------------------
#
# Add new PCA's
# 
#


source("bin/addPCAs.R")


# ---------------------------------------------
#
# 
# exclusion list
#

sample2exclude = as.character(snptestDF$ID_1[!snptestDF$ID_1 %in% voltab$sample.id])
sample2exclude = c(sample2exclude,
                   voltab$sample.id[!(voltab$hf_cm == 0 & voltab$mi == 0 & 
                                    (voltab$bmi > 16 & voltab$bmi < 40)) |
                                    (voltab$LVEF < 20 | voltab$LVEF > 80 | is.na(voltab$LVEF))
                                    ]
                   )
any(duplicated(sample2exclude))
length(sample2exclude)

sample2exclude_v2 = snptestDF$ID_1[!snptestDF$ID_1 %in% voltab$sample.id]
#sample2exclude_v2 = c(sample2exclude_v2,voltab$X[!(voltab$hf_cm == 0)])
length(sample2exclude_v2)


# ---------------------------------------------
#
# print
#

# print table bolt lmm

boltlmmDF = snptestDF
colnames(boltlmmDF) = c("FID","IID", names(typeLine)[-c(1,2)])

write.table(file = "../../data/ukbCMR.boltlmm_200316.sample",
            x = boltlmmDF,
            quote = F,
            col.names = T,
            row.names = F,
            sep = " "
)


plinkPhenocovar=boltlmmDF
plinkPhenocovar$genotyping.array = ifelse(plinkPhenocovar$genotyping.array == 1, "UKBB", "UKBL")

write.table(file = "../../data/ukbCMR.plinkPhenocovar_200316.sample",
            x = plinkPhenocovar,
            quote = F,
            col.names = T,
            row.names = F,
            sep = " "
)




plinkdf =snptestDF[,1:4]
plinkdf[is.na(plinkdf)] <- -9

write.table(file = "../../data/ukbCMR.plink_200316.sample",
            x = plinkdf,
            quote = F,
            col.names = T,
            row.names = F,
            sep = " "
)

dim(voltab)



# print typeLine add in bash
write.table(file = "../../data/typeLine",
            x = t(as.matrix(typeLine)),
            quote = F,
            col.names = T,
            row.names = F,
            sep = " "
)


# print table
write.table(file = "../../data/ukbCMR.snpTest_200316.sample",
            x = snptestDF,
            quote = F,
            col.names = F,
            row.names = F,
            sep = " "
)

system("cat ../../data/typeLine ../../data/ukbCMR.snpTest_200316.sample > tmp ; mv tmp ../../data/ukbCMR.snpTest_200316.sample")

write.table("../../data/sample2exclude.snpTest_200316.list",
            x = sample2exclude,
            quote = F,
            col.names = F,
            row.names = F
)


write.table("../../data/sample2exclude_v2.snpTest_200316.list",
            x = sample2exclude_v2,
            quote = F,
            col.names = F,
            row.names = F
)



dim(snptestDF)[1] -length(sample2exclude)
dim(snptestDF)[1] -length(sample2exclude_v2)

#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################


summary(lm(snptestDF$lapef ~ snptestDF$sex + snptestDF$age + 
             snptestDF$bsa + snptestDF$imgCenter +
             snptestDF$PC1 + snptestDF$PC2 + snptestDF$PC3 +
             snptestDF$PC4 + snptestDF$PC5 + snptestDF$PC6 +
             snptestDF$PC7 + snptestDF$PC8 + snptestDF$PC9))






