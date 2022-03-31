function a_fcwml_mri_firstlevel_ROI_couple(SUBJNAME)
% perform 1st level for FCWML
%
%BL 2021
%--------------------------------------------------------------------------
home='E:\NYU_RS_LC\';
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
savedir_1stlev=fullfile(stats_dir, 'template_1st_level_pipelines', 'smoothed', 'ROI_coupling', SUBJNAME);


% make stats dir if none
if ~exist(savedir_1stlev, 'dir')
    mkdir(savedir_1stlev);
end

load batch_file_firstlevel_concat_ROI_coupling_day2

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change output folder
matlabbatch{1}.spm.stats.fmri_spec.dir = {savedir_1stlev};

%change model (i.e. which regressor file to use)
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day2', 'func',...
    ['sub-', SUBJNAMEcbi, '_ses-day2_task-rest_acq-normal_run-01_bold'], 'log', 'ROI_coupling',...
    'firstlevel_final_regressors_ROI_coupling.mat')};


%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

% Delete files to save space
betass=dir(fullfile(savedir_1stlev,'beta*.nii'));
for i = 2:numel(betass)
    delete(fullfile(savedir_1stlev,betass(i).name));
end
delete(fullfile(savedir_1stlev,'mask.nii'));
delete(fullfile(savedir_1stlev,'ResMS.nii'));
delete(fullfile(savedir_1stlev,'RPV.nii'));
delete(fullfile(savedir_1stlev,'SPM.mat'));



