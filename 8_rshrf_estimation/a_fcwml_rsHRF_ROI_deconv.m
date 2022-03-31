function a_fcwml_rsHRF_ROI_deconv(SUBJNAME)

%--------------------------------------------------------------------------
%
% estimate HRF shape in each ROI
%
%BL 2021
%--------------------------------------------------------------------------

% SETTINGS
%%--------------------------------------------------------------------------
addpath 'E:\NYU_RS_LC\scripts\8_rshrf_estimation\'
addpath 'E:\NYU_RS_LC\scripts\8_rshrf_estimation\batch_files'
addpath 'E:\NYU_RS_LC\scripts\6_firstlevel'
addpath 'E:\NYU_RS_LC\scripts\0_general'
%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end

SUBJNAMEcbi=erase(SUBJNAME,'_');

%% check session --------------------------
% if session == 1
%     sess='ses-day-1';
%     sess_short = 'ses-day1';
% elseif session ==2 
%     sess='ses-day-2';
%     sess_short = 'ses-day2';
% end


%% Make output dir --------------------------
%make stats dir
Ddrive_data='D:\NYU_RS_LC\';
%Clus_data='/data/lloydb/data';
% remove old voxel-wise folder
% rm_dir_1stlev=fullfile(Edrive_data, SUBJNAME, sess_short, 'func', 'rsHRF_voxel-wise_output');
% 
% if exist(rm_dir_1stlev, 'dir')
%    rmdir(rm_dir_1stlev, 's');
% end

% make new voxel-wise folder + subfolders

%ROI = 'DMN_roi';
%canonical basis functions
%savedir_1stlev_canonical=fullfile(Edrive_data, 'stats', 'rsHRF', SUBJNAME, sess, '1_canonical');
savedir_1stlev_canonical=fullfile(Ddrive_data, 'stats', 'rsHRF', SUBJNAME, 'concat', '1_canonical', 'BF_rois');
if ~exist(savedir_1stlev_canonical, 'dir')
   mkdir(savedir_1stlev_canonical);
end
% 
% %gamma basis functions 
% savedir_1stlev_gamma=fullfile(Edrive_data, 'stats', 'rsHRF', SUBJNAME, sess, '2_gamma');
% if ~exist(savedir_1stlev_gamma, 'dir')
%    mkdir(savedir_1stlev_gamma);
% end
%% Temporal mask --------------------------
% load in temporal mask for subject session
%temp_mask=a_make_temporal_mask_hrfest(SUBJNAME,session)';
temp_mask_D1=a_make_temporal_mask_hrfest(SUBJNAME,1)';
temp_mask_D2=a_make_temporal_mask_hrfest(SUBJNAME,2)';
temp_mask_concat = [temp_mask_D1 temp_mask_D2];
%double_temp_mask=double(temp_mask);
double_temp_mask_concat=double(temp_mask_concat);

%% load batch: canonical basis functions
load 1_canonical_batchfile_BFrois

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change session if needed
% if session ==2
%     matlabbatch = struct_string_replace(matlabbatch,'ses-day-1',char(sess));
%     matlabbatch = struct_string_replace(matlabbatch,'ses-day1',char(sess_short));
% end

%input correct temporal mask
matlabbatch{1}.spm.tools.rsHRF.vox_rsHRF.HRFE.tmask=double_temp_mask_concat;

% change outputdir
matlabbatch{1}.spm.tools.rsHRF.ROI_rsHRF.outdir={savedir_1stlev_canonical};

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

% 
% %% load batch: gamma basis functions
% load 2_gamma_batchfile
% 
% %change subject code
% matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
% matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));
% 
% %change session if needed
% if session ==2
%     matlabbatch = struct_string_replace(matlabbatch,'ses-day-1',char(sess));
%     matlabbatch = struct_string_replace(matlabbatch,'ses-day1',char(sess_short));
% end
% 
% %input correct temporal mask
% matlabbatch{1}.spm.tools.rsHRF.vox_rsHRF.HRFE.tmask=double_temp_mask;
% 
% % change outputdir
% matlabbatch{1}.spm.tools.rsHRF.ROI_rsHRF.outdir={savedir_1stlev_gamma};
% 
% %run batch
% spm_jobman('run',matlabbatch); clear matlabbatch
% 
% 


