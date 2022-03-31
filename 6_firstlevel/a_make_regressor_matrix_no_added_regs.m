function [n_vox] = a_make_regressor_matrix_no_added_regs(SUBJNAME,session)

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


%--------------------------------------------------------------------------  
% Load in final_regressors "final_regressors.mat" --> RETROICOR +
% movement params
load(fullfile(inputim.path, 'log','final_regressors.mat'));

% Collapse 3 into 1 file
R=[R sigextr];   

%mkdir
save_filedir = fullfile(inputim.path, 'log', 'no_added_regs_of_interest');
if ~exist(save_filedir, 'dir')
    mkdir(save_filedir)
end

save(fullfile(save_filedir, ['firstlevel_final_regressors_no_added_regs.mat']),'R');


