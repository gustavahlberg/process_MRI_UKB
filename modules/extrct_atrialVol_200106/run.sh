#
#
# Created 191107
# run.sh: run script for 
# automated analysis of CMR
#
# 1. test
# 2. qsub all 
# 
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

module load moab
source activate cardiacMRI


module load vtk/8.2.0 
module load cuda92/toolkit 
module load intel/perflibs/2017_update2 boost/1.47.0 eigen/3.2.4 suitesparse/5.2.0
module load mirtk/2.0.0


# -----------------------------------------------------------
#
# test
#


N=test
mkdir -p results/${N}

python atrialVolume.py --data_root ../../data/${N} \
    --out_dir results/${N}



# -----------------------------------------------------------
#
# qsub
#


#N=32
msub -t 1-33%15 atrialVolume.pbs




# -----------------------------------------------------------
#
# concatenate all csv files
#

head -1 results/1/table_atrial_volume.csv > header 
cat results/*/table_atrial_volume.csv  | \
    grep -v HR | cat header - > results/table_atrial_volume_all.csv  




# -----------------------------------------------------------
#
# annotate curves
#

module load gdal/2.2.3
module load intel/perflibs/64
module load  R/3.6.1
currentdate=`date +"%Y%m%d"`
Rscript $DIR/Main.R > extrct_atrialAnnon_${currentdate}.log



#############################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#############################################################
