# -*- coding: utf-8 -*-
"""
Created on Wed Feb 17 11:42:25 2021

@author: lloydb
"""
import os
import shutil

# Script that moves around the folder to and from Seagate drive for PUP_LC study

# Path settings C drive
homepath = "C:\\Users\\lloydb\\surfdrive\\ExperimentData\\NYU_RS_LC"
datapath = os.path.join(homepath, 'data')
#path setting seagate
homepath_seagate = 'E:\\NYU_RS_LC'
datapath_seagate = os.path.join(homepath_seagate, 'data')


#define subject 
subjname = os.listdir(datapath)

for c_subj in subjname:
   
    # MAKE OVERLAP DIR 
    overlapdir = os.path.join(datapath_seagate, c_subj, 'ses-day2', 'ROI', 'LC', 'overlap')
    if not os.path.exists(overlapdir):
        os.makedirs(overlapdir)

    
    
    # MOVE MASKS TO/FROM SEAGATE
    # --------------------------------------------------------------------------
    # get old and new fodler 
    ROI_LC_path = os.path.join(datapath, c_subj, 'ses-day2', 'ROI', 'LC')
    save_ROI_LC_path = os.path.join(datapath_seagate, c_subj, 'ses-day2', 'ROI', 'LC')
    
    # copy the rater_1 rater_2  masks from old to new folder 
    src = ROI_LC_path
    dst = save_ROI_LC_path
    shutil.copytree(src, dst)

    # --------------------------------------------------------------------------




    # MOVE T1 TO/FROM SEAGATE
    # --------------------------------------------------------------------------
    # remove T1 on computer 
    T1_PATH = os.path.join(datapath, c_subj, 'ses-day2', 'anat')
    os.remove(T1_PATH)



