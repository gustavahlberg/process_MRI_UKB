#
# define HF and cardiomyopathy phenotype
# 
# ---------------------------------------------
#
# df
#


defCM = list(f.20002 = c("1079","1588"),
             f.41270 = c("I255","I42","I420","I421","I422","I425","I428","I429"),
             f.41271 = c("425","4251","4254"),
             exclude = c(0,0,0)
)

defHF = list(f.20002 = c("1076"),
             f.41270 = c("I110","I130","I132","I50","I500","I501","I517","I509"),
             f.41271 = c("428","4280", "4281", "4289"),
             exclude = c(0,0,0)
)


all(rownames(icdCodesList$ICD10) == voltab$sample.id)
nSamples = dim(icdCodesList$ICD10)[1]


# ---------------------------------------------
#
# HF & cardiomegly
# 

HFpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     stringsAsFactors = F
)


#icd 10
idxHF = which(icdCodesList$ICD10 %in% defHF$f.41270)
idxHF = unique(idxHF%%nSamples)
HFpheno$icd10[idxHF] <- 1

#icd 9
idxHF = which(icdCodesList$ICD9 %in% defHF$f.41271)
idxHF = unique(idxHF%%nSamples)
HFpheno$icd9[idxHF] <- 1

# self reported
idxHF = which(icdCodesList$illnessSelfreported %in% defHF$f.20002)
idxHF = unique(idxHF%%nSamples)
HFpheno$illSR[idxHF] <- 1

sum(rowSums(HFpheno[,-1]) >= 1)


# ---------------------------------------------
#
# CM
#


CMpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                     icd10 = rep(0, nSamples),
                     icd9 = rep(0, nSamples),
                     illSR = rep(0, nSamples),
                     stringsAsFactors = F
)


#icd 10
idxCM = which(icdCodesList$ICD10 %in% defCM$f.41270)
idxCM = unique(idxCM%%nSamples)
CMpheno$icd10[idxCM] <- 1

#icd 9
idxCM = which(icdCodesList$ICD9 %in% defCM$f.41271)
idxCM = unique(idxCM%%nSamples)
CMpheno$icd9[idxCM] <- 1

# self reported
idxCM = which(icdCodesList$illnessSelfreported %in% defCM$f.20002)
idxCM = unique(idxCM%%nSamples)
CMpheno$illSR[idxCM] <- 1

sum(rowSums(CMpheno[,-1]) >= 1)


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
