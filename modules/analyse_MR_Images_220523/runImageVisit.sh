#
#
# Created 220630
# run.sh: run script for 
# automated analysis of CMR, for first image visit 
#
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


module load cuda/toolkit/11.4.1
module load cudnn/11.4-8.2.4.15


module load vtk/8.2.0 
module load cuda/toolkit/9.2.148 
module load intel/perflibs/2017_update2
module load boost/1.47.0 eigen/3.2.4 suitesparse/5.2.0
module load mirtk/2.0.0
module load tensorflow/1.15.3-gpu



# -----------------------------------------------------------
#
# qsub all
#

# run all 
N=`find ../../data/imgVisit/. -maxdepth 1 -type d -printf "%f\n" | sort -nr | head -1`
echo $N


qsub -t 1-${N}%15 analyseCMRimages.pbs



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
