#
#
# Module for extracting LA measurments
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


inFn <- "results/table_atrial_volume_all.csv"
outFn <- "results/table_atrial_annotations_all.csv"
source("bin/load.R")


# ---------------------------------------------
#
# test
#

#source("bin/test.R")



# ---------------------------------------------
#
# annotate curves
#


source("bin/annotateAtrialPhase.R")


# ---------------------------------------------
#
# print annotations
#

laAnnotations$sample.id <- rownames(laAnnotations)

write.table(laAnnotations,
      file = outFn,
      col.names = T,
      row.names = T,
      quote = F,
      sep = "\t"
)
      


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
