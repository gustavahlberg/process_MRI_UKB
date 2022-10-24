#
#
# icd codes
#
#
# ---------------------------------------
#
# sample ids
#

h5ls(h5.fn)

sample.id = h5read(h5.fn,"sample.id")
colnames(sample.id) = "sample.id"
h5readAttributes(h5.fn,"f.22006")


# ----------------------------------------
#
# ICD etc..
#
# Date of first in-patient diagnosis - ICD10

h5readAttributes(h5.fn,"f.41280")
dateICD10 = h5read(h5.fn,"f.41280/f.41280")
colnames(dateICD10) = h5readAttributes(h5.fn,"f.41280/f.41280")$f.41280
rownames(dateICD10) <- sample.id[,1]
dateICD10 = dateICD10[sample.unrel.eth.cmr.id,]

# Date of first in-patient diagnosis - ICD9
h5readAttributes(h5.fn,"f.41281")
dateICD9 = h5read(h5.fn,"f.41281/f.41281")
colnames(dateICD9) = h5readAttributes(h5.fn,"f.41281/f.41281")$f.41281
rownames(dateICD9) <- sample.id[,1]
dateICD9 = dateICD9[sample.unrel.eth.cmr.id,]

# externalCauses data-coding 19
h5readAttributes(h5.fn,"f.41201")
externalCauses_datacoding19 = h5read(h5.fn,"f.41201/f.41201")
colnames(externalCauses_datacoding19) = h5readAttributes(h5.fn,"f.41201/f.41201")$f.41201
rownames(externalCauses_datacoding19) <- sample.id[,1]
externalCauses_datacoding19 = externalCauses_datacoding19[sample.unrel.eth.cmr.id,]

# Diagnoses -  ICD10
h5readAttributes(h5.fn,"f.41270")
ICD10 = h5read(h5.fn,"f.41270/f.41270")
colnames(ICD10) = h5readAttributes(h5.fn,"f.41270/f.41270")$f.41270
rownames(ICD10) <- sample.id[,1]
ICD10 = ICD10[sample.unrel.eth.cmr.id,]

# Diagnoses -  ICD9
h5readAttributes(h5.fn,"f.41271")
ICD9 = h5read(h5.fn,"f.41271/f.41271")
colnames(ICD9) = h5readAttributes(h5.fn,"f.41271/f.41271")$f.41271
rownames(ICD9) <- sample.id[,1]
ICD9 = ICD9[sample.unrel.eth.cmr.id,]

# Operative procedures - OPCS4
h5readAttributes(h5.fn,"f.41272")
OPCS4 = h5read(h5.fn,"f.41272/f.41272")
colnames(OPCS4) = h5readAttributes(h5.fn,"f.41272/f.41272")$f.41272
rownames(OPCS4) <- sample.id[,1]
OPCS4 = OPCS4[sample.unrel.eth.cmr.id,]


# Date of first operative procedure - OPCS4
h5readAttributes(h5.fn,"f.41282")
dateOPCS4 = h5read(h5.fn,"f.41282/f.41282")
colnames(dateOPCS4) = h5readAttributes(h5.fn,"f.41282/f.41282")$f.41282
rownames(dateOPCS4) <- sample.id[,1]
dateOPCS4 = dateOPCS4[sample.unrel.eth.cmr.id,]


# 20002	Non-cancer illness code, self-reported
h5readAttributes(h5.fn,"f.20002")
illnessSelfreported = h5read(h5.fn,"f.20002/f.20002")
colnames(illnessSelfreported) = h5readAttributes(h5.fn,"f.20002/f.20002")$f.20002
rownames(illnessSelfreported) <- sample.id[,1]
illnessSelfreported = illnessSelfreported[sample.unrel.eth.cmr.id,]

# 20004	Operation code, self reported
h5readAttributes(h5.fn,"f.20004")
opCodeSelfReported = h5read(h5.fn,"f.20004/f.20004")
colnames(opCodeSelfReported) = h5readAttributes(h5.fn,"f.20004/f.20004")$f.20004
rownames(opCodeSelfReported) <- sample.id[,1]
opCodeSelfReported = opCodeSelfReported[sample.unrel.eth.cmr.id,]

icdCodesList = list(ICD10 = ICD10,
                    dateICD10= dateICD10,
                    ICD9 = ICD9,
                    dateICD9 = dateICD9,
                    externalCauses_datacoding19 = externalCauses_datacoding19,
                    OPCS4 = OPCS4,
                    dateOPCS4 = dateOPCS4,
                    illnessSelfreported = illnessSelfreported,
                    opCodeSelfReported = opCodeSelfReported
)



str(icdCodesList)
rm(OPCS4,dateOPCS4,opCodeSelfReported,
   illnessSelfreported,ICD10,ICD9,
   dateICD10,dateICD9, externalCauses_datacoding19)



#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################



