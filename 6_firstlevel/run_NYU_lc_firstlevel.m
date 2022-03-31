%% This script does the following: 

% note: before running this - you need to have ran 'add_regressor' for each
% model

% 1. First-level analysis 
% 2. Moves contrasts 

%% Path settings ----------------------------------------------------------
home='F:\NYU_RS_LC\';
subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));
%addpath('E:\NYU_RS_LC\scripts\1_preproc');

%% Define which day -------------------------------------------------------
% 


%% Define subject numbers -------------------------------------------------
% settings: excl day 1/2
subjexcl_d1=[4, 15, 21, 37, 38, 47, 57, 62, 66, 69];   % subjs to excl from analysis day1 (note they are linked to order in list)
subjexcl_d1_temp=[4, 15, 21, 37, 47, 57, 66, 69]; 
subjexcl_d2_temp=[18, 19, 24, 29, 31, 52];             % subjs to excl from analysis day2
subjexcl_d2_everyone=[18, 19, 24, 29, 31, 32, 52, 62];      % number 38 and 62 are also excluded (but this messes up combi list)
subjexcl_d1_or_d2=[4,15,18,19,21,24,29,31,37,38,47,52,57,62,66,69];   % subjs inclided with only one sess (either 1 or 2)
list_total=[1:72];

list_concatsubjs=setdiff(list_total,subjexcl_d1_or_d2);   %57 subjs concatonated at 1st level. 


%% First-level analysis ---------------------------------------------------

%models={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};
models={'DR_roi', 'MR_roi', 'LC_roi', 'VTA_roi', 'SN_roi', 'DMN_roi', 'OCC_roi', 'ACC_roi', 'BF_sept_roi', 'BF_subl_roi'};
reg_name = {'rsHRF_ROI_models','vary_TTP_models'};
%models={'P1', 'P2', 'P3', 'P4', 'P5'};
%model = 'LC_native_space';
%day=1;
% 
% pup_type = {'pup_size', 'pup_deriv'};
% smooth = {'smoothed', 'unsmoothed'};

for mod = 10  %
        
    for day = 1:2
    %do not run excluded subjs
        if day==1 
            subjincl=subjexcl_d2_temp;
            disp(numel(subjincl));
        elseif day==2
            subjincl=subjexcl_d1_temp;
            disp(numel(subjincl));
        end
        
        for RN = 1
            % Loop over subjects
            for c_subj = subjincl% subjincl %  still need to run for subjs with only 1 day included!
        %subjincl c_subj =31
            
    
                disp(['now running subj ', subjlist(c_subj).name, 'model ', models{mod}, reg_name{RN}]);


                a_fcwml_mri_firstlevel(subjlist(c_subj).name, day, models{mod}, reg_name{RN}); 
            end
        end
    end
end
%end
