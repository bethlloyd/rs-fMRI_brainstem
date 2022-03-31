clear all; clc;

% Settings
subjpath='E:\NYU_RS_LC\data';

subjlist=dir(fullfile(subjpath,'MRI*'));

% Run each subject
for c_subj = 7:72
    
    subjlist(c_subj).name
    
    a_fcwml_mri_coreg_reslice_ROI(subjlist(c_subj).name)
  
end