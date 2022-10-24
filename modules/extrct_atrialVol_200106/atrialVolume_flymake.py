#
#
# analyse atrial volume 
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
        print('atrialVolume.py') 
        print('-d <data_root> -o <out_dir>')
        sys.exit(2)

    # read args
    for opt, arg in opts:
        if opt == '-h':
            print('atrialVolume.py')
            print('-d <data_root>')
            sys.exit()
        elif opt in ("-d", "--data_root"):
            data_root = arg
        elif opt in ("-o", "--out_dir"):
            out_dir = arg

    

    results_csv = out_dir
    if not os.path.exists(results_csv):
        os.makedirs(results_csv)




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
