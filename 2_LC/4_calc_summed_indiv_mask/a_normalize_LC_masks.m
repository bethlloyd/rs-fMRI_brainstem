function a_normalize_LC_masks(SUBJNAME)

%BL 2021
%--------------------------------------------------------------------------
home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts\2_LC\4_calc_summed_indiv_mask');
addpath('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\scripts');

%check subj name
SUBJNAMEcbi=erase(SUBJNAME,'_');


load normalize_masks_batch


%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));


%run batch
spm_jobman('run',matlabbatch); clear matlabbatch