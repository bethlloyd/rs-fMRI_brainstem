function a_fcwml_mri_firstlevel_replicate(SUBJNAME, session)


%--------------------------------------------------------------------------
%
% perform 1st level for FCWML replication of Murphy
%
%BL 2021
%--------------------------------------------------------------------------
home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts\6_firstlevel\batch_files');

% SETTINGS
%--------------------------------------------------------------------------
%check subj name
SUBJNAMEcbi=erase(SUBJNAME,'_');

%make stats dir
%Cdrive_stats='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\stats';
stats_dir=fullfile(homeD, 'stats');
savedir_1stlev=fullfile(stats_dir, 'template_1st_level_pipelines', 'smoothed', 'replication_methods', SUBJNAME);


% make stats dir if none
if ~exist(savedir_1stlev, 'dir')
    mkdir(savedir_1stlev);
end

%% run the first level
% SMOOTHED
%% SIZE
% day 1
if session==1
    %% Pupil size 
    pupsize_dir=fullfile(savedir_1stlev, 'pup_size');
    if ~exist(pupsize_dir, 'dir')
       mkdir(pupsize_dir);
    end

    load batch_file_firstlevel_replicate_D1
  
    %change subject code
    matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
    matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));
    
    %change output folder
    matlabbatch{1}.spm.stats.fmri_spec.dir = {pupsize_dir};
    
    %change model (i.e. which regressor file to use)
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day1', 'func',...
        ['sub-', SUBJNAMEcbi, '_ses-day1_task-rest_acq-normal_run-01_bold'], 'log', 'pup_size',...
        'replicate_methods', ['firstlevel_final_regressors_replicate_methods.mat'])};
    
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
    
% day 2   
elseif session==2
    %% Pupil size 
    pupsize_dir=fullfile(savedir_1stlev, 'pup_size');
    if ~exist(pupsize_dir, 'dir')
       mkdir(pupsize_dir);
    end

    load batch_file_firstlevel_replicate_D2

    %change subject code
    matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
    matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

    %change model (i.e. which regressor file to use)
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {fullfile(home, 'data', SUBJNAME, 'ses-day2', 'func',...
        ['sub-', SUBJNAMEcbi, '_ses-day2_task-rest_acq-normal_run-01_bold'], 'log', 'pup_size',...
        'replicate_methods', ['firstlevel_final_regressors_replicate_methods.mat'])};
    
    %change output folder
    matlabbatch{1}.spm.stats.fmri_spec.dir = {pupsize_dir};
    
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


end


