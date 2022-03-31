function [n_vox] = a_make_regressor_matrix_replication_meth(SUBJNAME,pup_type,session)

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
BOLD_dir=dir(fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',padi.BOLDpattern));
inputim.path=fullfile(padi.data,SUBJNAME,padi.sessions{session},'func',BOLD_dir.name);

BOLDim=dir(fullfile(inputim.path,['u' SUBJNAME '*']));
inputim.ims={BOLDim.name}';

% Extract signal
[sigextr, roixyz] = f_extract_BOLD_data(inputim, roitemplate,extrval);
sigextr=sigextr'-mean(sigextr); % demean the signal
% diaplay number of vox in 4th vent
disp(['Number of voxels in the 4th ventricle mask is: ' num2str(size(roixyz,2))])

% collect average number of voxels in 4th vent
n_vox=size(roixyz,2);
%--------------------------------------------------------------------------    
% Load in pupil regressor for each pup # 1 - Diameter

HRF_type={'canonical', 'temporal', 'dispersion'};
all_pup_vec = zeros(150,numel(HRF_type));
for c_hrf=1:numel(HRF_type)
    %Pupil path
    pup_dir=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\rawdata\', ...
                SUBJNAME, ['logfiles-' padi.sessions{session}], 'processed\smoothed\3_convolved', ['HRF_' HRF_type{c_hrf}]);

   if pup_type==1
        pup_filename=['pupil_dilation_' HRF_type{c_hrf} '_murphy.txt'];
        pupdat=fullfile(pup_dir, pup_filename);
         % open datafile
        fid=fopen(pupdat, 'r');
        pup_int = fscanf(fid,formatSpec);
        fclose(fid);
        savedir='pup_size';
        %append all pupile vectors in 1
        all_pup_vec(:,c_hrf)=pup_int;
      
    elseif pup_type==2 % Load in pupil regressor # 2 - Derivative
        deriv_pup_filename=['pupil_derivative_' HRF_type{c_hrf} '_murphy.txt'];
        deriv_pupdat=fullfile(pup_dir, deriv_pup_filename);
          % open datafile
        fid1=fopen(deriv_pupdat, 'r');
        pup_int = fscanf(fid1,formatSpec);
        fclose(fid1);
        savedir='pup_deriv';
        %append all pupile vectors in 1
        all_pup_vec(:,c_hrf)=pup_int;
    end
end

%--------------------------------------------------------------------------  
% Load in final_regressors "final_regressors.mat" --> RETROICOR +
% movement params
load(fullfile(inputim.path, 'log','final_regressors.mat'));

%--------------------------------------------------------------------------  
% get spike regressors with frame-wise displacement threshold (0.4mm)
%     if SR == 'Y'
%         [spikereg_matrix] = run_bramila_framewiseDisplacement(SUBJNAME, session);
%         % diaplay number flagged EPI vols and %
%         disp(['Number of flagged EPIs is: ' num2str(size(spikereg_matrix,2))]);
%         n_spikes = size(spikereg_matrix,2);
%     end
%     
%     
% Collapse 3 into 1 file
R=[all_pup_vec R sigextr];   

%mkdir
saveRfiledir = fullfile(inputim.path, 'log', savedir, 'replicate_methods');
if ~exist(saveRfiledir, 'dir')
    mkdir(saveRfiledir)
end

save(fullfile(saveRfiledir, ['firstlevel_final_regressors_replicate_methods.mat']),'R');


