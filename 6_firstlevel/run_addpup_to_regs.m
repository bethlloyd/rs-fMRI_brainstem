% Add the pupil regressor to the "final_regressors.mat" file which included
% the realigment parameters and RETROICORplus regressors

clear all; clc;

% Settings
%subjpath='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\data';
subjpath='F:\NYU_RS_LC\data';
subjlist=dir(fullfile(subjpath,'MRI*'));

% subject settings
subjexcl_d1=[15, 21, 37, 38, 47, 57, 62, 66, 69];   % subjs to excl from analysis day1 (note they are linked to order in list)
subjexcl_d2=[18, 19, 24, 29, 31, 38, 52, 62];             % subjs to excl from analysis day2 --> need to look at number 31 (subj 36)! -- pup int half the length!
list_total=[1:72];
% 
% if ~exist('day')
%     day=char(inputdlg('Which day?'));
% end; % select day here!


for day = 1:2
    if day==1
        subjincl=setdiff(list_total,subjexcl_d1);
        disp(numel(subjincl));
    elseif day==2
        subjincl=setdiff(list_total,subjexcl_d2);
        disp(numel(subjincl));
    end


    % Loop over subjects
    for c_subj = subjincl
        disp(['now running subj ', subjlist(c_subj).name]);

        for c_pup=1:2
      
            a_make_regressor_matrix_conv_ROI(subjlist(c_subj).name,c_pup,day);

        end
    end
end