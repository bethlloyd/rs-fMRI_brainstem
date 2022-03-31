function [r p] = a_extract_BS_signal_and_correlate(SUBJNAME,session, data_type)

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

%get dat type
if ~exist('data_type')
    data_type=char(inputdlg('1 for denoised, 2 for raw'));
end



%path settings
padi=i_fcwml_infofile(SUBJNAME);


%define the BS ROIs 
ROI={'LC_roi', 'VTA_roi', 'SN_roi', 'DR_roi', 'MR_roi', 'BF_roi'};
ROI_path = 'D:\NYU_RS_LC\masks\ROI_final';

% residual data folder 
RES_dat = 'D:\NYU_RS_LC\stats\BS_correlations\unsmoothed';

% raw data folder 
raw_dat = 'E:\NYU_RS_LC\data'; 
% GET DATA
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------       
if data_type == '1'  % denoise
    
    % Load in RESIDUAL data
    inputim.path=fullfile(RES_dat,SUBJNAME,padi.sessions{session});

    BOLDim=dir(fullfile(inputim.path,['Res_*']));
    inputim.ims={BOLDim.name}';
    
elseif data_type == '2'     % no denoising
    % Load in raw data 
    BOLD_pattern = dir(fullfile(raw_dat,SUBJNAME,padi.sessions{session},'func',['sub-*']));
    inputim.path = fullfile(BOLD_pattern.folder,BOLD_pattern.name);
    BOLDim=dir(fullfile(inputim.path,['aff_*']));
    inputim.ims={BOLDim.name}';
end

extrval=0.01;


for roi = 1:numel(ROI)
    
    %BS roi path
    ROI_folder=dir(fullfile(ROI_path, ROI{roi}, ['*.nii']));
    ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
    % extract signal
    [sigextr_roi, roixyz] = f_extract_BOLD_data(inputim, ROI_mask,extrval);
    sigextr_roi=sigextr_roi'-mean(sigextr_roi); % demean the signal
    ROI_sig_struct(1:150,roi)=sigextr_roi';

    
end
% pons ROI
ROI_folder=dir(fullfile(ROI_path,  'PONS_roi', ['*.nii']));
ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
% extract signal
[sigextr_roi, roixyz] = f_extract_BOLD_data(inputim, ROI_mask,extrval);
sigextr_roi_pons=sigextr_roi'-mean(sigextr_roi); % demean the signal


%correlated vectors 
[r p] = partialcorr(ROI_sig_struct, sigextr_roi_pons);





