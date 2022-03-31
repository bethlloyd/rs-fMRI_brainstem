clear all; clc;

home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';

subjpath='D:\NYU_RS_LC\stats\template_1st_level_pipelines\smoothed\DR_roi';
subjlist=dir(fullfile(subjpath,'MRI*'));
addpath('E:\NYU_RS_LC\scripts');
output_path = 'D:\NYU_RS_LC\stats\native_space_LC\unsmoothed';

%% Define subject numbers -------------------------------------------------
list_total=[1:71];


pupil={'pup_size', 'pup_deriv'};

%% Prepare scruct for saving z-values
perm_dat(1,1) = cellstr('subj');
perm_dat(1,2) = cellstr('LC');
% perm_dat(1,3) = cellstr('VTA');
% perm_dat(1,4) = cellstr('SN');
% perm_dat(1,5) = cellstr('DR');
% perm_dat(1,6) = cellstr('MR');

%% Define looped varaibles ---------------------------------------------------

for sess=1:2

    for pup=1:2
        for c_subj=list_total
            
            [z_score]=a_permutation_testing_fMRI_pup(subjlist(c_subj).name,sess,pup);
            
             % SAVE DATA
             %-------------------------------------------------------------
             perm_dat(c_subj+1,1) = cellstr(subjlist(c_subj).name);
             perm_dat(c_subj+1,2) = num2cell(z_score);
             
        end
        
        %make outputfile
        save_folder = fullfile(output_path, pupil{pup});
        filename=strcat(['day' num2str(sess) '_z_scores_permutation_LC_NATIVE.csv']);
        savefilename=fullfile(save_folder,filename);
        cell2csv(savefilename,perm_dat);
        
    end
end