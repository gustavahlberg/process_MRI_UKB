#
#
# Created 220630
# run.sh: run script for 
# automated analysis of CMR
#
# 1. test
# 2. runImageVisit.sh
# 3. runRepeatVisit.sh
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
# test
#

python analyseCMRimages.py --data_root ../../data/test2 \
       --out_dir results/test2


msub test.pbs




# -----------------------------------------------------------
#
# 2. runImageVisit.sh
#

bash ${DIR}/runImageVisit.sh



# -----------------------------------------------------------
#
# concatenate all csv files for first image visit
#


head -1 results/1/table_ventricular_volume.csv > header 
cat results/*/table_ventricular_volume.csv | \
    grep -v LVEDV | cat header - > results/table_ventricular_volume_all.csv

head -1 results/1/table_wall_thickness.csv > header 
cat results/*/table_wall_thickness.csv | \
    grep -v WT_AHA_1 | cat header - > results/table_wall_thickness_all.csv

head -1 results/1/table_atrial_volume.csv > header 
cat results/*/table_atrial_volume.csv | \
    grep -v LAV | cat header - > results/table_atrial_volume_all.csv



# -----------------------------------------------------------
#
# 3. runRepeatVisit.sh
#


bash ${DIR}/runRepeatVisit.sh



# -----------------------------------------------------------
#
# concatenate all csv files for repeat image visit
#


head -1 results/repImgVisit/1/table_ventricular_volume.csv > header 
cat results/repImgVisit/*/table_ventricular_volume.csv | \
    grep -v LVEDV | cat header - > results/table_ventricular_volume_repeat_all.csv

head -1 results/repImgVisit/1/table_wall_thickness.csv > header 
cat results/repImgVisit/*/table_wall_thickness.csv | \
    grep -v WT_AHA_1 | cat header - > results/table_wall_thickness_repeat_all.csv

head -1 results/repImgVisit/1/table_atrial_volume.csv > header 
cat results/repImgVisit/*/table_atrial_volume.csv | \
    grep -v LAV | cat header - > results/table_atrial_volume_repeat_all.csv


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
