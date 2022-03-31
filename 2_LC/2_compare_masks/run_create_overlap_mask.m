clear all; clc;

% Settings
subjpath='E:\NYU_RS_LC\data';

subjlist=dir(fullfile(subjpath,'MRI*'));
subjincl=[1:4,6:73];
% Run each subject
for c_subj = subjincl
    
    subjlist(c_subj).name
    
    a_fcwml_mri_overlapmask(subjlist(c_subj).name)
  
end