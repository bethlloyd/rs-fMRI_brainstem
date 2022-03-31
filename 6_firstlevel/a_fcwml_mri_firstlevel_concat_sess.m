function a_fcwml_mri_firstlevel_concat_sess(SUBJNAME,model,reg_name)

%% adapted now to concatonated version 
%--------------------------------------------------------------------------
%
% perform 1st level for FCWML
%
%BL 2021
%--------------------------------------------------------------------------
home='F:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts\6_firstlevel\batch_files');
addpath('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\scripts');
% SETTINGS
%--------------------------------------------------------------------------
%check subj name
SUBJNAMEcbi=erase(SUBJNAME,'_');

%make stats dir
%Cdrive_stats='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\stats';
stats_dir=fullfile(homeD, 'stats');
savedir_1stlev=fullfile(stats_dir, 'template_1st_level_pipelines', 'smoothed', model, SUBJNAME);

savedir_1stlev_unsmoothed=fullfile(stats_dir, 'template_1st_level_pipelines', 'unsmoothed', model, SUBJNAME);


% make stats dir if none
if ~exist(savedir_1stlev, 'dir')
    mkdir(savedir_1stlev);
end

% make stats dir if none
if ~exist(savedir_1stlev_unsmoothed, 'dir')
    mkdir(savedir_1stlev_unsmoothed);
end


%% SMOOTHED
%
%
%
%

%% Pupil size 
pupsize_dir=fullfile(savedir_1stlev, 'pup_size');
if ~exist(pupsize_dir, 'dir')
   mkdir(pupsize_dir);
end

load batch_file_firstlevel_concat

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change output folder
matlabbatch{1}.spm.stats.fmri_spec.dir = {pupsize_dir};

%change model (i.e. which regressor file to use)
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day1', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day1_task-rest_acq-normal_run-01_bold'], 'log', 'pup_size',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day2', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day2_task-rest_acq-normal_run-01_bold'], 'log', 'pup_size',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};


%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

% Delete files to save space
betass=dir(fullfile(pupsize_dir,'beta*.nii'));
for i = 2:numel(betass)
    delete(fullfile(pupsize_dir,betass(i).name));
end
delete(fullfile(pupsize_dir,'mask.nii'));
delete(fullfile(pupsize_dir,'ResMS.nii'));
delete(fullfile(pupsize_dir,'RPV.nii'));
delete(fullfile(pupsize_dir,'SPM.mat'));
   
% clear old day1 and day2 folders
rm_d1 = fullfile(pupsize_dir, 'ses-day-1');
rm_d2 = fullfile(pupsize_dir, 'ses-day-2');
if exist(rm_d1, 'dir')    
    rmdir(rm_d1, 's');
end

if exist(rm_d2, 'dir')    
    rmdir(rm_d2, 's');
end


%% Pupil DERIVATIVE
pupderiv_dir=fullfile(savedir_1stlev, 'pup_deriv');
if ~exist(pupderiv_dir, 'dir')
   mkdir(pupderiv_dir);
end

load batch_file_firstlevel_concat

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change output folder
matlabbatch{1}.spm.stats.fmri_spec.dir = {pupderiv_dir};

%change model (i.e. which regressor file to use)
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day1', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day1_task-rest_acq-normal_run-01_bold'], 'log', 'pup_deriv',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day2', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day2_task-rest_acq-normal_run-01_bold'], 'log', 'pup_deriv',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

% Delete files to save space
betass=dir(fullfile(pupderiv_dir,'beta*.nii'));
for i = 2:numel(betass)
    delete(fullfile(pupderiv_dir,betass(i).name));
end
delete(fullfile(pupderiv_dir,'mask.nii'));
delete(fullfile(pupderiv_dir,'ResMS.nii'));
delete(fullfile(pupderiv_dir,'RPV.nii'));
delete(fullfile(pupderiv_dir,'SPM.mat'));
    
 
% clear old day1 and day2 folders
rm_d1 = fullfile(pupderiv_dir, 'ses-day-1');
rm_d2 = fullfile(pupderiv_dir, 'ses-day-2');
if exist(rm_d1, 'dir')    
    rmdir(rm_d1, 's');
end

if exist(rm_d2, 'dir')    
    rmdir(rm_d2, 's');
end





%% UNSMOOTHED
%
%
%


%% Pupil size 
pupsize_dir=fullfile(savedir_1stlev_unsmoothed, 'pup_size');
if ~exist(pupsize_dir, 'dir')
   mkdir(pupsize_dir);
end

load batch_file_firstlevel_concat_UNSMOOTHED

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change output folder
matlabbatch{1}.spm.stats.fmri_spec.dir = {pupsize_dir};

%change model (i.e. which regressor file to use)
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day1', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day1_task-rest_acq-normal_run-01_bold'], 'log', 'pup_size',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day2', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day2_task-rest_acq-normal_run-01_bold'], 'log', 'pup_size',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

% Delete files to save space
betass=dir(fullfile(pupsize_dir,'beta*.nii'));
for i = 2:numel(betass)
    delete(fullfile(pupsize_dir,betass(i).name));
end
delete(fullfile(pupsize_dir,'mask.nii'));
delete(fullfile(pupsize_dir,'ResMS.nii'));
delete(fullfile(pupsize_dir,'RPV.nii'));
delete(fullfile(pupsize_dir,'SPM.mat'));
    
 
% clear old day1 and day2 folders
rm_d1 = fullfile(pupsize_dir, 'ses-day-1');
rm_d2 = fullfile(pupsize_dir, 'ses-day-2');
if exist(rm_d1, 'dir')    
    rmdir(rm_d1, 's');
end

if exist(rm_d2, 'dir')    
    rmdir(rm_d2, 's');
end



%% Pupil deriv
pupderiv_dir=fullfile(savedir_1stlev_unsmoothed, 'pup_deriv');
if ~exist(pupderiv_dir, 'dir')
   mkdir(pupderiv_dir);
end

load batch_file_firstlevel_concat_UNSMOOTHED

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change output folder
matlabbatch{1}.spm.stats.fmri_spec.dir = {pupderiv_dir};

%change model (i.e. which regressor file to use)
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day1', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day1_task-rest_acq-normal_run-01_bold'], 'log', 'pup_deriv',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day2', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day2_task-rest_acq-normal_run-01_bold'], 'log', 'pup_deriv',...
    reg_name, ['firstlevel_final_regressors_' model '.mat'])};

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

% Delete files to save space
betass=dir(fullfile(pupderiv_dir,'beta*.nii'));
for i = 2:numel(betass)
    delete(fullfile(pupderiv_dir,betass(i).name));
end
delete(fullfile(pupderiv_dir,'mask.nii'));
delete(fullfile(pupderiv_dir,'ResMS.nii'));
delete(fullfile(pupderiv_dir,'RPV.nii'));
delete(fullfile(pupderiv_dir,'SPM.mat'));
    


% clear old day1 and day2 folders
rm_d1 = fullfile(pupderiv_dir, 'ses-day-1');
rm_d2 = fullfile(pupderiv_dir, 'ses-day-2');
if exist(rm_d1, 'dir')    
    rmdir(rm_d1, 's');
end

if exist(rm_d2, 'dir')    
    rmdir(rm_d2, 's');
end





