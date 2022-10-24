# Evaluate the atrial area and length
# from 2 chamber or 4 chamber view images.
# Area per pixel

import numpy as np
import nibabel as nib
import vtk
import math
import sys
# sys.path.append(r'/home/projects/cu_10039/projects/cardiacMRI')
sys.path.append(r'/home/gustavahlberg')
from ukbb_cardiac.common.cardiac_utils import atrium_pass_quality_control,evaluate_atrial_area_length
from ukbb_cardiac.common.image_utils import *

label = seg_la_2ch[:, :, 0, t]
nim = nim_2ch


pixdim = nim.header['pixdim'][1:4]
area_per_pix = pixdim[0] * pixdim[1] * 1e-2  # Unit: cm^2

# Go through the label class
L = []
A = []
landmarks = []
labs = np.sort(list(set(np.unique(label)) - set([0])))

for i in labs:
    # The binary label map
    label_i = (label == i)
    
    # Get the largest component in case we have a bad segmentation
    label_i = get_largest_cc(label_i)
    
    # Go through all the points in the atrium,
    # sort them by the distance along the long-axis.
    points_label = np.nonzero(label_i)
    points = []
    for j in range(len(points_label[0])):
        x = points_label[0][j]
        y = points_label[1][j]
        points += [[x, y,
                    np.dot(np.dot(nim.affine,
                                  np.array([x, y, 0, 1]))[:3],
                           long_axis)]]

    points = np.array(points)
    points = points[points[:, 2].argsort()]

    # The centre at the top part of the atrium (top third)
    n_points = len(points)
    top_points = points[int(2 * n_points / 3):]
    cx, cy, _ = np.mean(top_points, axis=0)

    # The centre at the bottom part of the atrium (bottom third)
    bottom_points = points[:int(n_points / 3)]
    bx, by, _ = np.mean(bottom_points, axis=0)

    # Determine the major axis by connecting
    # the geometric centre and the bottom centre
    major_axis = np.array([cx - bx, cy - by])
    major_axis = major_axis / np.linalg.norm(major_axis)

    # Get the intersection between the major axis and the atrium contour
    px = cx + major_axis[0] * 100
    py = cy + major_axis[1] * 100
    qx = cx - major_axis[0] * 100
    qy = cy - major_axis[1] * 100

    if np.isnan(px) or np.isnan(py) or np.isnan(qx) or np.isnan(qy):
        return -1, -1, -1

    # Note the difference between nifti image index and cv2 image index
    # nifti image index: XY
    # cv2 image index: YX (height, width)
    image_line = np.zeros(label_i.shape)
    cv2.line(image_line, (int(qy), int(qx)), (int(py), int(px)), (1, 0, 0))
    image_line = label_i & (image_line > 0)

    # Sort the intersection points by the distance along long-axis
    # and calculate the length of the intersection
    points_line = np.nonzero(image_line)
    points = []
    for j in range(len(points_line[0])):
        x = points_line[0][j]
        y = points_line[1][j]
        # World coordinate
        point = np.dot(nim.affine, np.array([x, y, 0, 1]))[:3]
        # Distance along the long-axis
        points += [np.append(point, np.dot(point, long_axis))]

    points = np.array(points)
    if len(points) == 0:
        return -1, -1, -1

    points = points[points[:, 3].argsort(), :3]
    L += [np.linalg.norm(points[-1] - points[0]) * 1e-1]  # Unit: cm

    # Calculate the area
    A += [np.sum(label_i) * area_per_pix]

    # Landmarks of the intersection points
    landmarks += [points[0]]
    landmarks += [points[-1]]
    #return A, L, landmarks
