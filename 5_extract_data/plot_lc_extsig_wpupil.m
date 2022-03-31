
%path settings
padi=i_fcwml_infofile(SUBJNAME);

% roi path
ROI_path = 'F:\NYU_RS_LC\masks\ROI_final';
%BS roi path
ROI_folder=dir(fullfile(ROI_path, ['LC_roi'], ['*.nii']));
ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
%roitemplate='E:\NYU_RS_LC\masks\Keren mask\rLC_2SD_BINARY_TEMPLATE.nii';
%control_4th_vent_roi='E:\NYU_RS_LC\masks\4th_ventricle\rmni_control_4thvent.nii';

extrval = 1;
% GET DATA
%--------------------------------------------------------------------------
padi.BOLDpattern=fullfile('*task-rest_acq-normal_run-01_bold');

for c_sess = 1:numel(padi.sessions)

%--------------------------------------------------------------------------        
    % Load in BOLD data
    
    %get the BOLD images that are in the subject folder
    BOLD_dir=dir(fullfile('E:\NYU_RS_LC\data_MNI',SUBJNAME,padi.sessions{c_sess},'func',padi.BOLDpattern));
    inputim.path=fullfile('E:\NYU_RS_LC\data_MNI',SUBJNAME,padi.sessions{c_sess},'func',BOLD_dir.name);

    BOLDim=dir(fullfile(inputim.path,['swu' SUBJNAME '*']));
    inputim.ims={BOLDim.name}';
    inputim.ims=inputim.ims(6:end);
    
    if numel(inputim.ims)~=150
        disp('length of BOLD ims not 150')
    end
        
    % Extract signal 
    roixyz = [-2, -35, -16, 1]';
    [sigextr_lc, roixyz] = f_extract_BOLD_data(inputim, roitemplate,extrval);
    % centre the vector 
    
    disp(['Number of voxels in the mask is: ' num2str(size(roixyz,2))])
    
    [sigextr_4th_vent, roixyz] = f_extract_BOLD_data(inputim, control_4th_vent_roi,extrval);
    disp(['Number of voxels in the mask is: ' num2str(size(roixyz,2))])
    
    
    % load in raw pupil data
    pup_dir=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\data\', ...
        SUBJNAME, ['logfiles-' padi.sessions{c_sess}], 'processed\smoothed\2_downsampled');
    pup_filename='pupil_dilation.txt';
    pupdat=fullfile(pup_dir, pup_filename);
     % open datafile
    fid=fopen(pupdat, 'r');
    formatSpec = '%f';
    pup_int = fscanf(fid,formatSpec);
    fclose(fid);
    
    %centre the pup vector
    pup_int_z=(pup_int-mean(pup_int))/std(pup_int);
    sigextr_lc_z=(sigextr_lc'-mean(sigextr_lc))/std(sigextr_lc);
    sigextr_4th_vent_z=(sigextr_4th_vent'-mean(sigextr_4th_vent))/std(sigextr_4th_vent);
    %plot 
    plot(sigextr_lc_z, 'r'); hold on
    plot(sigextr_4th_vent_z, 'k');
    plot(pup_int_z, 'b');
    
    
    
    
    
    