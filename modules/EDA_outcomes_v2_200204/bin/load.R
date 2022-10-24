library(HDF5Array)
library(rhdf5)
library(dplyr)
library(R.utils)
library(data.table)
library(RColorBrewer)
library(car)
library(MASS)
library(randtests)
library(lmtest)
library(olsrr)
library(RNOmni)
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("HDF5Array")


PROJ_DATA="~/Projects_2/ManageUkbb/data/phenotypeFile/"
h5.fn <- paste(PROJ_DATA,"ukb39513.all_fields.h5", sep = '/')
sample.id = h5read(h5.fn,"sample.id")[,1]



