%% This script does the following: 

% note: before running this - you need to have ran 'add_regressor' for each
% model

% 1. First-level analysis 
% 2. Moves contrasts 

%% Path settings ----------------------------------------------------------
home='F:\NYU_RS_LC\';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));

%% Define which day -------------------------------------------------------


%% Define subject numbers -------------------------------------------------
% settings: excl day 1/2
subjexcl_d1=[4, 15, 21, 37, 38, 47, 57, 62, 66, 69];   % subjs to excl from analysis day1 (note they are linked to order in list)
subjexcl_d2=[18, 19, 24, 29, 31, 38, 52];             % subjs to excl from analysis day2

subjexcl_d1_or_d2=[4,15,18,19,21,24,29,31,37,38,47,52,57,62,66,69];   % subjs inclided with only one sess (either 1 or 2)
list_total=[1:72];

list_concatsubjs=setdiff(list_total,subjexcl_d1_or_d2);   %57 subjs concatonated at 1st level. 


%% First-level analysis ---------------------------------------------------

%models={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};
models={'DR_roi', 'MR_roi', 'LC_roi', 'VTA_roi', 'SN_roi', 'DMN_roi', 'OCC_roi', 'ACC_roi', 'BF_sept_roi', 'BF_subl_roi'};

pup_type = {'pup_size', 'pup_deriv'};
smooth = {'smoothed', 'unsmoothed'};

for mod = 9:10
        
%     for day = 1:2
%         %do not run excluded subjs
%         if day==1 
%             subjincl=setdiff(list_total,subjexcl_d1);
%             disp(numel(subjincl));
%         elseif day==2
%             subjincl=setdiff(list_total,subjexcl_d2);
%             disp(numel(subjincl));
%         end
        
    %for pup = 1:numel(pup_type)
        %for sm = 1:numel(smooth)
            
    % Loop over subjects
    for c_subj = 1  % run on subjs to concat across sessions
        %subjincl
        disp(['running..' subjlist(c_subj).name]);
        a_fcwml_mri_firstlevel_concat_sess(subjlist(c_subj).name, models{mod}, 'rsHRF_ROI_models');
%                 old_folder = fullfile('D:\NYU_RS_LC\', 'stats', 'template_1st_level_pipelines',...
%                     smooth{sm}, models{mod}, subjlist(c_subj).name, pup_type{pup}, 'ses-day-2');
%                 new_folder = fullfile('D:\NYU_RS_LC\', 'stats', 'template_1st_level_pipelines',...
%                     smooth{sm}, models{mod}, subjlist(c_subj).name, pup_type{pup});
% 
%                 niilist=dir(fullfile(old_folder,  '*nii'));
%                 %loop over contrasts
%                 for c_nii=1:numel(niilist)
% 
% 
% 
%                     %copy file
%                     copyfile(...
%                         fullfile(old_folder,niilist(c_nii).name),...
%                         new_folder);        
% 
%                 end
%                 
%                 if exist(old_folder, 'dir')    
%                     rmdir(old_folder, 's');
%                 end
    end

end
