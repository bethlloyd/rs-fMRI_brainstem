%% This script runs the rs HRF ROI batch
% 
clear all 
clc


%% Path settings ----------------------------------------------------------
home='F:\NYU_RS_LC\data';
subjlist=dir(fullfile(home,'MRI*'));

%% Define which day -------------------------------------------------------


%% Define subject numbers -------------------------------------------------


%% rs_HRF analysis ---------------------------------------------------


%for day = 1:2
% Loop over subjects
for c_subj = 1:72  
    subjlist(c_subj).name


    % send this function to the cluster 
    disp(['running subject...' subjlist(c_subj).name]);
    a_fcwml_rsHRF_ROI_deconv(subjlist(c_subj).name);



end
    
%end








