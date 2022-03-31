% Add the pupil regressor to the "final_regressors.mat" file which included
% the realigment parameters and RETROICORplus regressors

clear all; clc;

% Settings
%subjpath='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\data';
subjpath='D:\NYU_RS_LC\data';
subjlist=dir(fullfile(subjpath,'MRI*'));

% subject settings
list_total=[1:72];
% remove 44 and 145 --> c_subj 38 & 62
run_subs = [1:37,39:61, 63:72];


% Loop over subjects
for c_subj = run_subs
    disp(['now running subj ', subjlist(c_subj).name]);

    for c_pup=1:2

        a_moveContrasts_1pup(subjlist(c_subj).name,c_pup);

    end
end
