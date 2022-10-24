#
#
# Created 220706
# parse to analyseCMRimages.py 
#
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#source activate cardiacMRI

module load cuda/toolkit/11.4.1
module load cudnn/11.4-8.2.4.15


module load vtk/8.2.0 
#module load cuda/toolkit/9.2.148 
#module load intel/perflibs/2017_update2
module load boost/1.47.0 eigen/3.2.4 suitesparse/5.2.0
module load mirtk/2.0.0
module load tensorflow/1.15.3-gpu



N=$1

# -----------------------------------------------------------
#
# run
#

mkdir -p results/${N}

python analyseCMRimages.py --data_root ${DIR}/../../data/imgVisit/${N} \
       --out_dir ${DIR}/results/${N}
