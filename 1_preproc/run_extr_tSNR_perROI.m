clear all; clc;

% Settings
subjpath='D:\NYU_RS_LC\data';
subjlist=dir(fullfile(subjpath,'MRI*'));
homeE='E:\NYU_RS_LC';

addpath('E:\NYU_RS_LC\scripts');
% define session
session = {'ses-day1', 'ses-day2'};

% len_ims
len_ims=1;
extrval = 0.1;
% roi masks: 
roi_path = 'F:\NYU_RS_LC\masks\ROI_final';
ROI={'LC_roi', 'VTA_roi', 'SN_roi', 'DR_roi', 'MR_roi', 'BF_roi', 'ACC_roi', 'OCC_roi'};

%roi_mask_file = {'bin_rehandrawnLC_T_template0_FSE.nii', 'bin_reT_template0_DR_mask.nii', 'bin_reT_template0_MR_mask.nii', 'bin_reT_template0_VTA_r+l_mask.nii',...
%    'reT_template0_SN_r+l_mask.nii', 'reT_template_calcrine_l+r.nii', 'bin_T_template_ant_cingulum_r+l.nii'};


% Run each subject
for c_sess = 1:2
    for c_subj = 1:72
        for c_roi = 1:numel(ROI)
            ROI_folder=dir(fullfile(roi_path, ROI{c_roi}, ['*.nii']));
            ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
            
            subjlist(c_subj).name
            [tSNR] = a_extr_tSNR_perROI(subjlist(c_subj).name, session{c_sess},...
                len_ims, ROI_mask, extrval);
            
              % SAVE DATA
                    %--------------------------------------------------------------------------

            extract_tsnr(1, 1)=cellstr('subj');
            extract_tsnr(1, c_roi+1)=cellstr(ROI{c_roi});

            extract_tsnr(c_subj+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
            extract_tsnr(c_subj+1,c_roi+1)=num2cell(tSNR);
            
            stats_dir=fullfile(homeE, 'stats');
            
            statspath=fullfile(stats_dir, 'tsnr');
            %make outputfile 
            output_path = fullfile(statspath, 'groupstats', session{c_sess});
             % make output dir if none
            if ~exist(output_path, 'dir')
                mkdir(output_path);
            end

            filename=strcat('tSNR.csv');
            savefilename=fullfile(output_path,filename);
            cell2csv(savefilename,extract_tsnr);

        end
        
    end
end