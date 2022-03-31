function a_fcwml_mri_skullstrip(SUBJNAME)

%--------------------------------------------------------------------------
%
% perform preproc steps for FCWML
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

load f_skullstripped_batch

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch
