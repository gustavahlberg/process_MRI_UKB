#
#
# Module for defining list of etnhically matched and
# unrelated samples
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR=system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")



#sum(sample.unrel.eth.id %in% wttab$X)
source("bin/load.R")
sample.eth.id = as.character(read.table("../../data/sampleList.etn_200219.tsv",
                                              stringsAsFactors = F,
                                              header = F)$V1)


ttnvar = read.table(file = "../../data/ttnvar.raw",
                    header = T,
                    stringsAsFactors = F)

qcTab = read.table("../../data/cardiacMRI_samples.etn_200219.tsv",
                   stringsAsFactors = F,
                   header = T)


# ---------------------------------------------
#
# EDA outcomes
#


source("bin/cmrMeasurements.R")
samplesCMR = as.character(voltab$sample.id)


# ---------------------------------------------
#
# remove sex mismatches
#


source("bin/rmSexMismatch.R")
dim(voltab)

# ---------------------------------------------
#
# icd.R
#


source("bin/icd.R")



# ---------------------------------------------
#
# covarites table
#


source("bin/cov.R")



# ---------------------------------------------
#
# Explore association 2 af and stroke
#


source("bin/assoc_stroke_af.R")


# ---------------------------------------------
#
# Indexed and rank transformed LA varibles
#

source("bin/indexNrtrn_LA.R")



# ---------------------------------------------
#
# Make snptest table
#

source("bin/makeSnptestTable.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
