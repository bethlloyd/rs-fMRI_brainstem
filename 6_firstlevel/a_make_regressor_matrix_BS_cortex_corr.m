function [n_vox] = a_make_regressor_matrix_BS_cortex_corr(SUBJNAME,session)

% ADD REGRESSORS TO MAKE FINAL .MAT FILE
%--------------------------------------------------------------------------
% author: BL 2021

% PATH SETTINGS
%--------------------------------------------------------------------------
addpath('E:\NYU_RS_LC\scripts');
addpath('E:\NYU_RS_LC\scripts\0_general');


%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end


%path settings
padi=i_fcwml_infofile(SUBJNAME);


%define 4th ventricle ROI 
mask_filename=strcat('r4th_vent.nii');
roitemplate=fullfile(padi.roi,'4th_ventricle', mask_filename);
extrval=1;
formatSpec = '%f';

%define the BS ROIs 
ROI={'LC_roi', 'VTA_roi', 'SN_roi', 'DR_roi', 'MR_roi'};
ROI_path = 'D:\NYU_RS_LC\Template_space_masks';


% GET DATA
%--------------------------------------------------------------------------
padi.BOLDpattern=fullfile('*task-rest_acq-normal_run-01_bold');

%--------------------------------------------------------------------------        
% Load in BOLD data

%get the native BOLD images that are in the subject folder for 4th
%ventricle
BOLD_dir=dir(fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',padi.BOLDpattern));
inputim.path=fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',BOLD_dir.name);

BOLDim=dir(fullfile(inputim.path,['u' SUBJNAME '*']));
inputim.ims={BOLDim.name}';

% Extract 4th ventricle signal
[sigextr, roixyz] = f_extract_BOLD_data(inputim, roitemplate,extrval);
sigextr=sigextr'-mean(sigextr); % demean the signal
% diaplay number of vox in 4th vent
disp(['Number of voxels in the 4th ventricle mask is: ' num2str(size(roixyz,2))])

% collect average number of voxels in 4th vent
n_vox=size(roixyz,2);
%--------------------------------------------------------------------------    

% Get the template BOLD images (smoothed) for BS roi extraction
BOLD_dir=dir(fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',padi.BOLDpattern));
inputim.path=fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',BOLD_dir.name);

BOLDim=dir(fullfile(inputim.path,['saff_u' SUBJNAME '*']));
inputim.ims={BOLDim.name}';
extrval=0.1;

for roi = 1:numel(ROI)
    
    %BS roi path
    ROI_folder=dir(fullfile(ROI_path, ROI{roi}, ['*.nii']));
    ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
    % extract signal
    [sigextr_roi, roixyz] = f_extract_BOLD_data(inputim, ROI_mask,extrval);
    sigextr_roi=sigextr_roi'-mean(sigextr_roi); % demean the signal
    % diaplay number of vox in 4th vent
    disp(['Number of voxels in the ' ROI{roi} ' is: ' num2str(size(roixyz,2))])


    ROI_sig_struct(1:150,roi)=sigextr_roi';

end

%--------------------------------------------------------------------------  
% Load in final_regressors "final_regressors.mat" --> RETROICOR +
% movement params
load(fullfile(inputim.path, 'log','final_regressors.mat'));

% Collapse 3 into 1 file
R=[ROI_sig_struct R sigextr];   

%mkdir
save_filedir = fullfile(inputim.path, 'log', 'ROI_coupling');
if ~exist(save_filedir, 'dir')
    mkdir(save_filedir)
end

save(fullfile(save_filedir, ['firstlevel_final_regressors_ROI_coupling.mat']),'R');


