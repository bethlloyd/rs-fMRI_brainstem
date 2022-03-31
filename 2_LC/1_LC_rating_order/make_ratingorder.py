# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 10:17:56 2020

@author: lloydb
"""

import os
import random as rnd
from stimfuncs import resrand, makeiti, savetxt   


# Path settings
homepath = "E:\\NYU_RS_LC"
raw_datapath = os.path.join(homepath, 'rawdata')
datapath = os.path.join(homepath, 'data')
script_LC = os.path.join(homepath, 'scripts', '2_LC')

n_raters = [1, 2]
subject_list = os.listdir(datapath)

for c in range(len(n_raters)):
    rnd.seed(30) #whenever you run you get the same order
    rnd.shuffle(subject_list)

    save_path = os.path.join(script_LC, 'LC_rating_order', 'order_rater_' + str(n_raters[c]) + '.txt')
    savetxt(subject_list, save_path)


# make directories to save .roi files 
for subj in range(len(subject_list)):
    
    for c in range(len(n_raters)):
    
        dirname = os.path.join(datapath, os.listdir(datapath)[subj], 'ses-day2', 'ROI', 'LC', 'rater_' + str(n_raters[c]))
        
        if not os.path.exists(dirname):
            os.makedirs(dirname)