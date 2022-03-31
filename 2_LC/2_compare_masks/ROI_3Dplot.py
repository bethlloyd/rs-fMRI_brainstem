#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 15 15:48:21 2021

@author: lindvoo
"""

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
from nilearn.image import load_img, get_data

# This import registers the 3D projection, but is otherwise unused.
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import


# Read in images
img1 = load_img('E:\\NYU_RS_LC\\masks\\Keren mask\\r_thresh_keren_LC_2SD.nii')
img2 = load_img('E:\\NYU_RS_LC\\masks\\Template_space_masks\\rhand-drawn_LC_template0_FSE.nii')
voxels1 = get_data(img1)#.astype(np.int)
voxels2 = get_data(img2)#.astype(np.int)  

           
# Remove slices that do not contain the ROI [reduce comp load and easy plotting]
whichslices=[]
for c,val in enumerate(voxels1[:,0,0]):
    
    if (np.sum(voxels1[c,:,:]))>0:
        whichslices.append(c)

voxels1 = voxels1[whichslices[0]:whichslices[-1],:,:]
voxels2 = voxels2[whichslices[0]:whichslices[-1],:,:]


whichslices=[]
for c,val in enumerate(voxels1[0,0,:]):
    
    if (np.sum(voxels1[:,:,c]))>0:
        whichslices.append(c)

voxels1 = voxels1[:,:,whichslices[0]:whichslices[-1]]
voxels2 = voxels2[:,:,whichslices[0]:whichslices[-1]]

whichslices=[]
for c,val in enumerate(voxels1[0,:,0]):
    
    if (np.sum(voxels1[:,c,:]))>0:
        whichslices.append(c)

voxels1 = voxels1[:,whichslices[0]:whichslices[-1],:]
voxels2 = voxels2[:,whichslices[0]:whichslices[-1],:]

# Figure 1 - Keren Mask
fig1 = plt.figure()
ax1 = fig1.gca(projection='3d')
ax1.voxels(np.transpose(voxels1, (2, 1, 0)),
          edgecolor='k')
plt.show()

# Figure 2 - Hand drawn
fig2 = plt.figure()
ax2 = fig2.gca(projection='3d')
ax2.voxels(np.transpose(voxels2, (2, 1, 0)),
          edgecolor='k')
plt.show()

# Make boolean to create a figure with both
bool_voxels1 = np.zeros(voxels1.shape, dtype=bool)
bool_voxels2 = np.zeros(voxels2.shape, dtype=bool)
for x,xval in enumerate(voxels1[:,0,0]):
    for y,yval in enumerate(voxels1[0,:,0]):
        for z,xval in enumerate(voxels1[0,0,:]):
    
            bool_voxels1[x,y,z] = voxels1[x,y,z]>0
            bool_voxels2[x,y,z] = voxels2[x,y,z]>0


# Create overlap
combined = bool_voxels1 | bool_voxels2
overlap = bool_voxels1 & bool_voxels2

# Figure 3 - overlap
fig3 = plt.figure()
ax3 = fig3.gca(projection='3d')
ax3.voxels(np.transpose(overlap, (2, 1, 0)),
          edgecolor='k')
plt.show()
 
# set the colors of each object
colors = np.empty(overlap.shape, dtype=object)
colors[bool_voxels1] = 'blue'   # Keren
colors[bool_voxels2] = 'green'    # Handdrawn
colors[overlap] = 'darkblue'      # Overlap

# Plot  np.transpose(overlap, (2, 1, 0))
fig = plt.figure()
ax = fig.gca(projection='3d')
ax.voxels(np.transpose(combined, (2, 1, 0)), 
          facecolors=np.transpose(colors, (2, 1, 0)),
          alpha=.4)
ax.grid(False)
# Hide axes ticks
ax.set_xticks([])
ax.set_yticks([])
ax.set_zticks([])
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('z')

plt.show()