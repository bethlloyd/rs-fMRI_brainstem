function f_get_mask_size(ROI_name)

addpath('E:\NYU_RS_LC\scripts\0_general');
% define resolution 
res_EPI=[1.8*1.8*1.8]; %2*2*2

% mask folder 
mask_folder = ['F:\NYU_RS_LC\masks\ROI_final\', ROI_name];
mask_file=dir(fullfile(mask_folder, '*.nii'));
%get mask coordinates
roixyz = f_NYULC_threeDfind(fullfile(mask_file.folder, mask_file.name),.2);

% Calculate mm3
qMM=size(roixyz,2)*res_EPI

%x = y * z 

%180 = y * 5.832