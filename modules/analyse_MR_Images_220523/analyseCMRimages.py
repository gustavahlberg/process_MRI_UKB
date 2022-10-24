#
#
# analyseCMRimages.py 
#
#
# ==============================================================================
"""
    This script demonstrates a pipeline for cardiac MR image analysis.
    """
import os
import urllib.request
import shutil
import getopt
import sys 

def main(argv):

    try:
        opts, args = getopt.getopt(argv, "hd:o:", 
                                   ["data_root=", "out_dir="])
    except getopt.GetoptError:
        print('analyseCMRimages.py') 
        print('-d <data_root> -o <out_dir>')
        sys.exit(2)

    # read args
    for opt, arg in opts:
        if opt == '-h':
            print('analyseCMRimages.py') 
            print('-d <data_root>')
            sys.exit()
        elif opt in ("-d", "--data_root"):
            data_root = arg
        elif opt in ("-o", "--out_dir"):
            out_dir = arg

    

    results_csv = out_dir
    # results_csv = os.path.join(out_dir, "results_csv")

    # The GPU device id
    CUDA_VISIBLE_DEVICES = 0

    # spreadsheet
    if not os.path.exists(results_csv):
        os.makedirs(results_csv)

    # Analyse show-axis images
    print('******************************')
    print('  Short-axis image analysis')
    print('******************************')

    # Deploy the segmentation network
    print('Deploying the segmentation network ...')
    #os.system('python bin/deploy_network.py --seq_name sa --data_dir {0} '
    #          '--model_path trained_model/FCN_sa'.format(data_root))

    os.system('CUDA_VISIBLE_DEVICES={0} python bin/deploy_network.py --seq_name sa --data_dir {1} '
              '--model_path trained_model/FCN_sa'.format(CUDA_VISIBLE_DEVICES, data_root))


    # Evaluate ventricular volumes
    print('Evaluating ventricular volumes ...')
    os.system('python bin/eval_ventricular_volume.py --data_dir {0} '
              '--output_csv {1}/table_ventricular_volume.csv'.format(data_root, results_csv))

    # Evaluate wall thickness
    print('Evaluating myocardial wall thickness ...')
    os.system('python bin/eval_wall_thickness.py --data_dir {0} '
              '--output_csv {1}/table_wall_thickness.csv'.format(data_root, results_csv))


    
# Analyse long-axis images
    print('******************************')
    print('  Long-axis image analysis')
    print('******************************')

    # Deploy the segmentation network
    print('Deploying the segmentation network ...')
    os.system('python bin/deploy_network.py --seq_name la_2ch --data_dir {0} '
              '--model_path trained_model/FCN_la_2ch'.format(data_root))

    os.system('python bin/deploy_network.py --seq_name la_4ch --data_dir {0} '
              '--model_path trained_model/FCN_la_4ch'.format(data_root))

    os.system('python bin/deploy_network.py --seq_name la_4ch --data_dir {0} '
              '--seg4 --model_path trained_model/FCN_la_4ch_seg4'.format(data_root))

    # Evaluate atrial volumes
    print('Evaluating atrial volumes ...')
    os.system('python bin/eval_atrial_volume.py --data_dir {0} '
              '--output_csv {1}/table_atrial_volume.csv'.format(data_root, results_csv))

    print('Done.')


# ------------------------------------------------------
#
# Start (send to main)
#

if __name__ == "__main__":
    main(sys.argv[1:])


###################### EOF ##########################
####################################################
