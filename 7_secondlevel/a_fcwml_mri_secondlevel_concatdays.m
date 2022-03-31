function a_fcwml_mri_secondlevel_concatdays(model, smoothed, pup_type, neg_pos)
%--------------------------------------------------------------------------
%
% perform 1st level for FCWML
%
%BL 2021
%--------------------------------------------------------------------------
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts\7_secondlevel');
addpath('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\scripts');

% SETTINGS
%--------------------------------------------------------------------------

%make stats dir
%Cdrive_stats='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\stats';
stats_dir=fullfile(homeD, 'stats');

statspath=fullfile(stats_dir, 'template_1st_level_pipelines', smoothed, model,'groupstats', pup_type);

%get dirs
%conpaths=dir(fullfile(statspath,'T*'));

% RUN ANALYSES
%--------------------------------------------------------------------------

%loop over contrasts for one sample t test
%or c_con=1:numel(conpaths)
    
    
load batch_second_level_concat_days
    
    	
savedir_2ndlev = fullfile(stats_dir, 'template_2nd_level_pipelines', smoothed, model, pup_type, 'both_days', neg_pos, 'T_test');
    
% make output dir if none
if ~exist(savedir_2ndlev, 'dir')
    mkdir(savedir_2ndlev);
end



%     %get confiles
%     conpath=fullfile(statspath,conpaths(c_con).name);
%     confiles=cellstr(spm_select('List',conpath,['^.*\.nii']));
%    
%     if session == 'ses-day-1'
%         confiles(4) = [];  % remove subject 4 from analysis (stripey thingy)
%     end
%     

%     %get confiles
%     conpath=fullfile(statspath,conpaths(c_con).name);
%     confiles=cellstr(spm_select('List',conpath,['^.*\.nii']));

%change input
matlabbatch{1}.spm.stats.factorial_design.dir = {savedir_2ndlev};
matlabbatch = struct_string_replace(matlabbatch,'DR_roi',model);
matlabbatch = struct_string_replace(matlabbatch,'smoothed',smoothed);
matlabbatch = struct_string_replace(matlabbatch,'pup_size',pup_type);
matlabbatch = struct_string_replace(matlabbatch,'T_pos1',neg_pos);
if neg_pos == 'T_neg1'
    matlabbatch = struct_string_replace(matlabbatch,'con_0001','con_0002');
end
%select own spm defaults files [altered threshold]
i_spm_defaults

%run job
spm_jobman('run',matlabbatch); clear matlabbatch

%end



