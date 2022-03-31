function a_extract_signal_regressors(SUBJNAME)

% EXTRACT BOLD SIGNAL WITH ROI MASKS
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

% GET DATA
%--------------------------------------------------------------------------
padi.BOLDpattern=fullfile('*task-rest_acq-normal_run-01_bold');

for c_sess = 1:numel(padi.sessions)

%--------------------------------------------------------------------------        
    % Load in BOLD data
    
    %get the BOLD images that are in the subject folder
    BOLD_dir=dir(fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func',padi.BOLDpattern));
    inputim.path=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func',BOLD_dir.name);

    BOLDim=dir(fullfile(inputim.path,['u' SUBJNAME '*']));
    inputim.ims={BOLDim.name}';
    
    % Extract sign
    [sigextr, roixyz] = f_extract_BOLD_data(inputim, roitemplate,extrval);
    sigextr=sigextr'-mean(sigextr);
    disp(['Number of voxels in the mask is: ' num2str(size(roixyz,2))])
    
%--------------------------------------------------------------------------    
    % Load in pupil regressor # 1 - Diameter
    %Pupil path
    pup_dir=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\data\', ...
        SUBJNAME, ['logfiles-' padi.sessions{c_sess}], 'processed\smoothed\3_convolved\HRF_canonical');
    pup_filename='pupil_dilation_conv_zscore.txt';
    pupdat=fullfile(pup_dir, pup_filename);
     % open datafile
    fid=fopen(pupdat, 'r');
    formatSpec = '%f';
    pup_int = fscanf(fid,formatSpec);
    fclose(fid);
    
    % Load in pupil regressor # 2 - Derivative
    deriv_pup_filename='pupil_derivative_conv_zscore.txt';
    deriv_pupdat=fullfile(pup_dir, deriv_pup_filename);
      % open datafile
    fid1=fopen(deriv_pupdat, 'r');
    deriv_pup_int = fscanf(fid1,formatSpec);
    fclose(fid1);
    
%--------------------------------------------------------------------------  
    % Load in final_regressors "final_regressors.mat"
    finRegressor_dir=fullfile(inputim.path, 'log');
    finRegressor_file=dir(fullfile(finRegressor_dir,'final_regressors.mat'));
    load(finRegressor_file.name);
    
%--------------------------------------------------------------------------  
    % Collapse 3 into 1 file
    
    R=[R sigextr pup_int];   %check order of regressors
    save(fullfile(inputim.path, 'log', 'firstlevel_final_regressors_HRF_zscore.mat'),'R')
    
end

