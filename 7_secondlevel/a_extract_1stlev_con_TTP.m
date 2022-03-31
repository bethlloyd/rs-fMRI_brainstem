function [con_stat] = a_extract_1stlev_con_TTP(SUBJNAME, roi, TTP_mod, pup_type)

% EXTRACT BETA SCORES FOR ROI MASKS
%--------------------------------------------------------------------------
% author: BL 2021

% PATH SETTINGS
%--------------------------------------------------------------------------

%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end
% SETTINGS
%--------------------------------------------------------------------------
home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts\7_secondlevel');
addpath('E:\NYU_RS_LC\scripts\0_general');



%make stats dir
%Cdrive_stats='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\stats';
stats_dir=fullfile(homeD, 'stats');
statspath=fullfile(stats_dir, 'template_1st_level_pipelines', 'smoothed', TTP_mod);

%make outputfile 
output_path = fullfile(statspath, 'groupstats', pup_type, 'extract_stat');
 % make output dir if none
if ~exist(output_path, 'dir')
    mkdir(output_path);
end


%roi mask file path
mask_path = fullfile(homeD, 'masks', 'ROI_final', roi);
%define ROI filenames
ROI_mask=dir(fullfile(mask_path, '*nii'));

mask_theshold=0.1;
% Add header
%extracteddata(1, 1)=cellstr('con0001_stat');


%% Get con stat data 
con_dir=fullfile(statspath, SUBJNAME, pup_type);
con_im=dir(fullfile(con_dir, 'spmT_0001.nii'));
    
    

%get hdr of roi
r_hdr=spm_vol(fullfile(mask_path, ROI_mask.name));
        
%get the con map hdr
c_hdr=spm_vol(fullfile(con_im.folder, con_im.name));
            
%check dimentions
% if abs(sum(sum(c_hdr.mat-r_hdr.mat)))>0
%     error('ROI and CONTRAST MAP are not in the same space!')
% end
            
%get roi coordinates
roixyz = f_NYULC_threeDfind(r_hdr,mask_theshold);
            
%get number of voxels:
num_voxels=numel(spm_get_data(c_hdr,roixyz));
            
%get the data from the conmap based on the ROI
con_stat=mean(spm_get_data(c_hdr,roixyz));
            

