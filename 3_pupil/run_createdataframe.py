#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 13 11:39:37 2022

@author: lindvoo
"""

#Library
import sys
import os
import glob
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
#Add nideconv library
libfolder='C:\\Users\\lloydb\\surfdrive\\ExperimentData\\toolbox\\nideconv-master'
sys.path.append(libfolder)




# Run example
# ------------------------------------------------------------------------
#data, onsets, params = nd.simulate.simulate_fmri_experiment(n_subjects=3)
'''
                        area 1
    subj_idx run t
    1        1   0.0 -1.280023
                 1.0  0.908086
                 2.0  0.850847
                 3.0 -1.010475
                 4.0 -0.299650
    >>> print(data.onsets)
                                  onset
    subj_idx run event_type
    1        1   A            94.317361
                 A           106.547084
                 A           198.175115
                 A            34.941112
                 A            31.323272
'''

# Prepare paths
# ------------------------------------------------------------------------

# Location of the events
onsetspath='F:\\NYU_RS_LC\\stats\\rsHRF\\groupstats\\1_canonical\\event_onsets'
save_plots = 'F:\\NYU_RS_LC\\stats\\rsHRF\\groupstats\\1_canonical\\devonv_BOLD_events_nideconv'
# Location of the timecourse
timecoursepath='C:\\Users\\lloydb\\surfdrive\\ExperimentData\\NYU_RS_LC\\rawdata'

os.listdir(timecoursepath)

# Subjects
subjlist=os.listdir(timecoursepath)

excl_subjs=['MRI_FCWML004', 'MRI_FCWML016', 'MRI_FCWML020', 'MRI_FCWML022', 'MRI_FCWML025', 
            'MRI_FCWML028', 'MRI_FCWML033', 'MRI_FCWML036', 'MRI_FCWML043',
            'MRI_FCWML044', 'MRI_FCWML055', 'MRI_FCWML064', 'MRI_FCWML119', 
            'MRI_FCWML145', 'MRI_FCWML160', 'MRI_FCWML219']

subjlist_incl = list(set(subjlist) - set(excl_subjs))


rois = ['LC', 'VTA', 'SN', 'DR', 'MR', 'BF_subl', 'ACC', 'OCC']
time_secs = [0]

sF = 50

# Make 'onsets'
# ------------------------------------------------------------------------

for t in time_secs:
    
    all_roi_array=list()
    all_onsets_array=list()
    all_subj_array=list()
    all_run_array=list()
    all_control_array=list()
    
    # Loop over subjects and collect the onsets
    for c_subj, n_subj in enumerate(subjlist_incl):
        
        # Subject arrays
        roi_array=list()
        control_array=list()
        onsets_array=list()
        subj_array=list()
        run_array=list()
        # Collect subject files
        subjfiles = glob.glob(os.path.join(onsetspath, n_subj + '*'))
        
        # Loop over files
        for filename in subjfiles:
            
            # Read in
            df = pd.read_csv(filename, index_col='subj')
        
            # Get onsets
            onsets_array_temp = [int(val) for val in df.values]
            
            # Convert from TR to seconds :
            onsets_array_sec = [float(x*2) for x in onsets_array_temp]
            
            # flip both sessions for control onsets [<300 day1, >300 day2]
            day1_control = [x-300 for x in onsets_array_sec if x >300]
            day2_control = [x+300 for x in onsets_array_sec if x <300]

            # Add reversed onsets to new array
            control_array_onsets = day1_control + day2_control

            # Time shift: adjust the onset back by a second from 0 to 6 s
            onsets_adj = [x-t for x in onsets_array_sec if x>t]
            onsets_array.extend(onsets_adj)
            onsets_array.extend(control_array_onsets)
            
            # Create ROI array
            roi_array.extend(list(df.columns) * len(onsets_adj))
            
            # Create Control arrays [reversed session onsets]
            roi_array.extend(list(df.columns+'_control') * len(control_array_onsets))
            
        # Create subj array
        subj_array.extend([n_subj] * len(roi_array))
        
        # Create run array
        run_array.extend([1] * len(roi_array))
        
        # Collect subjects
        all_roi_array.extend(roi_array)
        all_onsets_array.extend(onsets_array)
        all_subj_array.extend(subj_array)
        all_run_array.extend(run_array)
        
    # Create multi index DF
    arrays = [all_subj_array,all_run_array,all_roi_array]
    tuples = list(zip(*arrays))
    index = pd.MultiIndex.from_tuples(tuples, names=["subject", "run", "event_type"])
    new_df_onsets = pd.Series(all_onsets_array,  index=index)
    
    new_df_onsets = new_df_onsets.to_frame('onset')
    


    
    # Make 'data'
    # ------------------------------------------------------------------------
    
    all_sample_array=list()
    all_tc_array=list()
    all_subj_array=list()
    all_run_array=list()
    # Loop over subjects and collect the onsets
    for c_subj, n_subj in enumerate(subjlist_incl):
           
        # Load in data
        pupday1 = pd.read_csv(os.path.join(timecoursepath,n_subj,'logfiles-ses-day1','processed', 'smoothed','1_orig','pupil_dilation.txt'),names=['signal'])
        pupday2 = pd.read_csv(os.path.join(timecoursepath,n_subj,'logfiles-ses-day2','processed', 'smoothed','1_orig','pupil_dilation.txt'),names=['signal'])
    
        dat1 = [int(val) for val in pupday1.values]
        dat2 = [int(val) for val in pupday2.values]
        
        # Time course array
        tc_array = dat1 + dat2
        tc_array_cen = (tc_array-np.average(tc_array))/np.std(tc_array)
        
        # Create subj array
        subj_array = [n_subj] * len(tc_array)
        
        # Creat run array
        run_array = [1] * len(tc_array)
        
        # Sample index array
        sample_array = [*range(0, len(tc_array), 1)]
        sample_array = [float(val) for val in sample_array]
        
        # Collect subjects
        all_sample_array.extend(sample_array)
        all_tc_array.extend(tc_array)
        all_subj_array.extend(subj_array)
        all_run_array.extend(run_array)
    
    # Create multi index DF
    arrays = [all_subj_array,all_run_array,all_sample_array]
    tuples = list(zip(*arrays))
    index = pd.MultiIndex.from_tuples(tuples, names=["subject", "run","t"])
    new_df_data = pd.Series(all_tc_array, index=index)
    new_df_data = new_df_data.to_frame('pupil')
        
        
        
    
    for i, c_roi in enumerate(rois):
        plt.subplot(2, 3, i)
        
             # fit all subjs
        g_model = nd.GroupResponseFitter(new_df_data,
                                  new_df_onsets,
                                  input_sample_rate=sF,
                                  concatenate_runs=False)
        
        g_model.add_event(c_roi,
                          basis_set='fourier',
                          n_regressors=9,
                          interval=[0, 10])
        
        g_model.add_event(c_roi+'_control',
                          basis_set='fourier',
                          n_regressors=9,
                          interval=[0, 10])
        
        
        g_model.fit()
        fig = plt.figure()
        g_model.plot_groupwise_timecourses()
        #plt.savefig(os.path.join(save_plots, 'group_plots', 'z-scored_devonv_group_pup_BOLD_' + c_roi + '_shift' + str(t) + '.pdf'), dpi = 1200)
        plt.close()
        
        
        
