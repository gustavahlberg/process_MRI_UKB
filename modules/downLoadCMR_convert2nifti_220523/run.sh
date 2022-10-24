#
#
# Created 220523
# run.sh: run script for 
# dowloading and converting cardiac dicom images to nifti
#
# 1. test
# 2. divide sample list
# 3. qsub all 
# 
# -----------------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

source activate cardiacMRI

# -----------------------------------------------------------
#
# 1 test
#

python download_data_ukbb_general.py \
    --data_root ../../data/test \
    --util_dir /home/projects/cu_10039/projects/ManageUkbb/bin/ \
    --ukbkey /home/projects/cu_10039/projects/process_MRI_UKB/.ukbkey \
    --csv_file ../../data/test/test.bulk \
    --instance 2


# -----------------------------------------------------------
#
# 2. Init epoch list
#

# set to TRUE/FALSE (default FALSE)
bash divideIntoLists.sh TRUE


# -----------------------------------------------------------
#
# 2. qsub all
#

touch downloadList.txt

N=`find ../../data/imgVisit/* -type d -printf "%f\n" | sort -nr | head -1`
echo $N

qsub -t 1-$N%15 download_data_ukbb_general.pbs




# -----------------------------------------------------------
#
# 4. find and rerun failed runs
#

Rscript find_N_list_failed.R
N=`find ../../data/imgVisit/*/ukbb_CMR_*_rerun.bulk  | wc -l`
echo $N

qsub -t 1-$N%15 download_data_ukbb_general_rerun.pbs


# -----------------------------------------------------------
#
# 4. find and rerun missing runs
#

Rscript find_N_list_missing.R

N=`cat reRunFileList.txt | wc -l`
echo $N

qsub -t 1-$N%15 download_data_ukbb_missing_rerun.pbs




# -----------------------------------------------------------
#
# 5. qsub all rep images
#


N=`find ../../data/repImgVisit/* -type d -printf "%f\n" | sort -nr | head -1`
echo $N

qsub -t 1-$N%15 download_data_ukbb_repeat_general.pbs



# -----------------------------------------------------------
#
# 4. find and rerun missing runs
#


Rscript find_N_list_missing_repeatVisit.R
# ... 


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
