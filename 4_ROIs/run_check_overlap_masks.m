clear all; clc;

% Settings
subjpath='E:\NYU_RS_LC\data';

subjlist=dir(fullfile(subjpath,'MRI*'));

% Run each subject
for c_subj = 1:numel(subjlist)
    
    %subjlist(c_subj).name
    
    f_check_overlap_masks(subjlist(c_subj).name)
  
end