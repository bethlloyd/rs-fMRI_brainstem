function [tSNR] = a_extr_tSNR_perROI(SUBJNAME, session, len_ims, roi_mask, extrval)
% inputs: 

% SUBJNAME = subject name/code
% session = i.e. day1, day2 (for path definition) 
% len_ims = number of functional images in one session
% roi_mask = path and ROI mask name i.e. ''E:\NYU_RS_LC\masks\Keren mask\rLC_2SD_BINARY_TEMPLATE.nii''
% extrval = set threshold for mask to extract signal 

%% Calculate tSNR 
% this script uses function f_extract_BOLD_data to extract tSNR in
% different brain regions (using ROI masks). 
% Saves a .csv file with a tSNR value (per session, per subject) 


%% path settings 
homeE='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';

addpath('E:\NYU_RS_LC\scripts\0_general');  % f_extract_BOLD_data in here

%get the tSNR images that are in the subject folder
%BOLD_dir=dir(fullfile(homeE,'stats', 'tsnr', SUBJNAME,session));
%BOLD_dir=BOLD_dir(3);
inputim.path=fullfile(homeE,'stats', 'tsnr', SUBJNAME,session);

BOLDim=dir(fullfile(inputim.path,['tSNR_im.nii']));
inputim.ims={BOLDim.name}';


% check for correct number of func ims
if numel(inputim.ims)~=len_ims
    disp('length of BOLD ims not correct length')
end

% extract signal 
[sigextr, roixyz] = f_extract_BOLD_data(inputim, roi_mask, extrval);

tSNR=sigextr;




