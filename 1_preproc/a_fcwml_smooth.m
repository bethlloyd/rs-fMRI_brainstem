function a_fcwml_smooth(SUBJNAME, session)

%--------------------------------------------------------------------------
%
% smooth fun images
%
%BL 2021
%--------------------------------------------------------------------------

% SETTINGS
%%--------------------------------------------------------------------------


addpath 'E:\NYU_RS_LC\scripts\1_preproc'
addpath 'E:\NYU_RS_LC\scripts\6_firstlevel\batch_files'
addpath 'E:\NYU_RS_LC\scripts\0_general'
%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end

if session == 1
    sess='ses-day-1';
    sess_short = 'ses-day1';
elseif session ==2 
    sess='ses-day-2';
    sess_short = 'ses-day2';
end

%load paths
SUBJNAMEcbi=erase(SUBJNAME,'_');


load batch_file_1stlev_save_residuals


%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

%change session if needed
if session ==2
    matlabbatch = struct_string_replace(matlabbatch,'ses-day-1',char(sess));
    matlabbatch = struct_string_replace(matlabbatch,'ses-day1',char(sess_short));
end


%run batch
spm_jobman('run',matlabbatch); clear matlabbatch








