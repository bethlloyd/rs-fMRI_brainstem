function a_fcwml_mri_secondlevel(model, smoothed, pup_type)
%--------------------------------------------------------------------------
%
% perform 1st level for FCWML
%
%BL 2021
%--------------------------------------------------------------------------
home='E:\NYU_RS_LC\';
homeD='F:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts\7_secondlevel');


% SETTINGS
%--------------------------------------------------------------------------

%make stats dir
%Cdrive_stats='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\stats';
stats_dir=fullfile(homeD, 'stats');

statspath=fullfile(stats_dir, 'template_1st_level_pipelines', smoothed, model,'groupstats', pup_type);

%get dirs
conpaths=dir(fullfile(statspath,'T*'));

% RUN ANALYSES
%--------------------------------------------------------------------------

%loop over contrasts for one sample t test
for c_con=1:numel(conpaths)
    
    
    load batch_second_level
    
    	
%     savedir_2ndlev_d1 = fullfile(stats_dir, 'template_2nd_level_pipelines', smoothed, model, pup_type, 'ses-day-1');
%     savedir_2ndlev_d2 = fullfile(stats_dir, 'template_2nd_level_pipelines', smoothed, model, pup_type, 'ses-day-2');
%     if exist(savedir_2ndlev_d1, 'dir')    
%         rmdir(savedir_2ndlev_d1, 's');
%     end
%     if exist(savedir_2ndlev_d2, 'dir')    
%         rmdir(savedir_2ndlev_d2, 's');
%     end
    
    savedir_2ndlev = fullfile(stats_dir, 'template_2nd_level_pipelines', smoothed, model, pup_type, conpaths(c_con).name, 'T_test');
    % make output dir if none
    if ~exist(savedir_2ndlev, 'dir')
        mkdir(savedir_2ndlev);
    end

    %get confiles
    conpath=fullfile(statspath,conpaths(c_con).name);
    confiles=cellstr(spm_select('List',conpath,['^.*\.nii']));
   
%     if session == 'ses-day-1'
%         confiles(4) = [];  % remove subject 4 from analysis (stripey thingy)
%     end
    

    %get confiles
    conpath=fullfile(statspath,conpaths(c_con).name);
    confiles=cellstr(spm_select('List',conpath,['^.*\.nii']));

   %change input
    matlabbatch{1}.spm.stats.factorial_design.dir = {savedir_2ndlev};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = ...
        strcat(conpath,filesep,confiles);

      %select own spm defaults files [altered threshold]
    i_spm_defaults
    
    %run job
    spm_jobman('run',matlabbatch); clear matlabbatch

end



