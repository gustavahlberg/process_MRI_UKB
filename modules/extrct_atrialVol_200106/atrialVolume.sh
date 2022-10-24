source activate cardiacMRI
module load vtk/8.2.0 
module load cuda92/toolkit 
module load intel/perflibs/2017_update2 boost/1.47.0 eigen/3.2.4 suitesparse/5.2.0
module load mirtk/2.0.0

N=$1

python atrialVolume.py --data_root ../../data/${N} \
    --out_dir results/${N}
