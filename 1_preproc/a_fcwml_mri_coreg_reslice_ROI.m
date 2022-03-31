function a_fcwml_mri_coreg_reslice_ROI(SUBJNAME)

%--------------------------------------------------------------------------
%
% perform coreg reslice to EPI on ROI masks
%
%BL 2021
%--------------------------------------------------------------------------
addpath 'C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\scripts'

%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end


% PARAMETERS
%--------------------------------------------------------------------------
%load paths
padi=i_fcwml_infofile(SUBJNAME);
SUBJNAMEcbi=erase(SUBJNAME,'_');

load f_coreg_reslice_mask_batch

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch
