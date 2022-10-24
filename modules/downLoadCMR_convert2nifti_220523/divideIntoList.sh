#
# Created 220628
# divideIntoList.sh: run script for 
# dividing sample list to 1...N
#
# 1. select a subset of bulk file list w/ fields 
# 20208: Long axis heart images - DICOM Heart MRI
# 20209: Short axis heart images - DICOM Heart MRIs
#
# 2. divide into list of 1...-N
# 3. put each list into folder 1...-N
# 
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

INIT="${1:-FALSE}"


# -----------------------------------------------------------
#
# 1. select a subset of bulk file list w/ fields 
#



# epoch list created 220628
bulkFn=/home/projects/cu_10039/data/UKBB/phenotypeFn/ukb49511.bulk
cat $bulkFn | grep -E "20208|20209|20210" > ukb_CMR_la_sa_ao.epoch.220628.bulk 

# 


# -----------------------------------------------------------
#
# 2. divide into list of A-Z
#


if [ $INIT = TRUE ]  ; then
    echo "Divinding samples to lists for download (using epoch.bulk list)"
    Rscript divideIntoList.R
fi

if [ $INIT = FALSE ]  ; then
    echo "Adding new samples to lists for download"
    Rscript addNewSamplesToList.R
fi


#Rscript divideIntoList.R


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
