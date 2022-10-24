#
# define AF
# 
# ---------------------------------------------
#
# df
#

defAF = list(f.20002 = c(1471, 1483),
             f.20004 = c(1524),
             f.41270 = c("I48"),
             f.41271 = c("4273"),
             f.41272 = c("K571", "K621", "K622", "K623", "K624"),
             exclude = c(0,0,0,0,0)
)



nSamples = dim(icdCodesList$ICD10)[1]


# ---------------------------------------------
#
# AF
# 


AFpheno = data.frame(sample.id = rownames(icdCodesList$ICD10),
                        icd10 = rep(0, nSamples),
                        icd9 = rep(0, nSamples),
                        opcs4 = rep(0, nSamples),
                        illSR = rep(0, nSamples),
                        opSR = rep(0, nSamples),
                        stringsAsFactors = F
)


#icd 10
table(icdCodesList$ICD10[grep(defAF$f.41270, icdCodesList$ICD10 )])
#idx = which(icdCodesList$ICD10 %in% defAF$f.41270)
idx = grep(defAF$f.41270, icdCodesList$ICD10)
icdCodesList$ICD10[idx]
idx = unique(idx%%nSamples)
AFpheno$icd10[idx] <- 1


#icd 9
icdCodesList$ICD9[grep(defAF$f.41271, icdCodesList$ICD9)]
idx = which(icdCodesList$ICD9 %in% defAF$f.41271)
idx = unique(idx%%nSamples)
AFpheno$icd9[idx] <- 1

# self reported
idx = which(icdCodesList$illnessSelfreported %in% defAF$f.20002)
icdCodesList$illnessSelfreported[idx]
idx = unique(idx%%nSamples)
AFpheno$illSR[idx] <- 1
sum(rowSums(AFpheno[,-1]) >= 1)


# opcs4
table(icdCodesList$OPCS4[icdCodesList$OPCS4 %in% defAF$f.41272])
idx = which(icdCodesList$OPCS4 %in% defAF$f.41272)
icdCodesList$OPCS4[idx]
idx = unique(idx%%nSamples)
AFpheno$opcs4[idx] <- 1
sum(rowSums(AFpheno[,-1]) >= 1)


# opertation self reported
idx = which(icdCodesList$opCodeSelfReported %in% defAF$f.20004)
idx = unique(idx%%nSamples)
AFpheno$opSR[idx] <- 1
sum(rowSums(AFpheno[,-1]) >= 1)







