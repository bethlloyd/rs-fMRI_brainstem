function a_addup_nuisance_regs(SUBJNAME)

% ADD REGRESSORS TO MAKE FINAL .MAT FILE
%--------------------------------------------------------------------------
% author: BL 2021

% PATH SETTINGS
%--------------------------------------------------------------------------

%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end


%path settings
padi=i_fcwml_infofile(SUBJNAME);

%define ROI filenames
mask_filename=strcat('r4th_vent.nii');
roitemplate=fullfile(padi.roi,'4th_ventricle', mask_filename);
extrval=1;
formatSpec = '%f';

% GET DATA
%--------------------------------------------------------------------------
padi.BOLDpattern=fullfile('*task-rest_acq-normal_run-01_bold');

%--------------------------------------------------------------------------        
% Load in BOLD data

%get the BOLD images that are in the subject folder
% BOLD_dir=dir(fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',padi.BOLDpattern));
% inputim.path=fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',BOLD_dir.name);
% 
% BOLDim=dir(fullfile(inputim.path,['u' SUBJNAME '*']));
% inputim.ims={BOLDim.name}';

BOLD_dir_D1=dir(fullfile(padi.data,SUBJNAME,padi.sessions{1},'func',padi.BOLDpattern));
inputim_D1.path=fullfile(padi.data,SUBJNAME,padi.sessions{1},'func',BOLD_dir_D1.name);

BOLDim_D1=dir(fullfile(inputim_D1.path,['u' SUBJNAME '*']));
inputim_D1.ims={BOLDim_D1.name}';

% Extract signal
[sigextr_D1, roixyz] = f_extract_BOLD_data(inputim_D1, roitemplate,extrval);
sigextr_D1=sigextr_D1'-mean(sigextr_D1);
% diaplay number of vox in 4th vent
disp(['Number of voxels in the mask is: ' num2str(size(roixyz,2))])




BOLD_dir_D2=dir(fullfile(padi.data,SUBJNAME,padi.sessions{2},'func',padi.BOLDpattern));
inputim_D2.path=fullfile(padi.data,SUBJNAME,padi.sessions{2},'func',BOLD_dir_D2.name);

BOLDim_D2=dir(fullfile(inputim_D2.path,['u' SUBJNAME '*']));
inputim_D2.ims={BOLDim_D2.name}';

% Extract signal
[sigextr_D2, roixyz] = f_extract_BOLD_data(inputim_D2, roitemplate,extrval);
sigextr_D2=sigextr_D2'-mean(sigextr_D2);
% diaplay number of vox in 4th vent
disp(['Number of voxels in the mask is: ' num2str(size(roixyz,2))])

   
%--------------------------------------------------------------------------  
% Load in final_regressors "final_regressors.mat"
load(fullfile(inputim_D1.path, 'log','final_regressors.mat'));

%--------------------------------------------------------------------------  
% Collapse 3 into 1 file
RD1=[R sigextr_D1];   %check order of regressors


%--------------------------------------------------------------------------  
% Load in final_regressors "final_regressors.mat"
load(fullfile(inputim_D2.path, 'log','final_regressors.mat'));

%--------------------------------------------------------------------------  
% Collapse 3 into 1 file
RD2=[R sigextr_D2];   %check order of regressors

R_concat = [RD1;RD2];


savedir=fullfile(padi.data,SUBJNAME, 'concat', 'log','hrf_est_regressors');
%mkdir
if ~exist(savedir, 'dir')
    mkdir(savedir)
end



save(fullfile(savedir, 'hrf_est_regressionmatrix.mat'),'R_concat');



