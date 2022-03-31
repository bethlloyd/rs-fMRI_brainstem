clear all; clc;

% Settings
subjpath='D:\NYU_RS_LC\data';

subjlist=dir(fullfile(subjpath,'MRI*'));

% Run each subject
for c_subj = 12:72
    
    for c_sess = 1:2
        subjlist(c_subj).name

        f_fcwml_calc_tsnr(subjlist(c_subj).name, c_sess)
        
        
    end
end