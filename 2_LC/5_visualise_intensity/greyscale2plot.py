# -*- coding: utf-8 -*-
"""
Created on Tue Aug 31 08:39:43 2021

@author: lloydb
"""
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import cv2

# generate some sample data
import scipy.misc
lena = cv2.imread("033_greyscale.png", 0)

# downscaling has a "smoothing" effect
lena = cv2.resize(lena, (100,100))

 
# create the x and y coordinate arrays (here we just use pixel indices)
xx, yy = np.mgrid[0:lena.shape[0], 0:lena.shape[1]]

# create the figure
fig = plt.figure()
ax = fig.gca(projection='3d')
ax.plot_surface(xx, yy, lena ,rstride=1, cstride=1, cmap=plt.cm.jet,
                linewidth=0)

# show it
plt.axis('off')
plt.show()