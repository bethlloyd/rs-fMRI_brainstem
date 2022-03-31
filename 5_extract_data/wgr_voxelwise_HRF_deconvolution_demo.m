%% demo code for voxel-wise HRF deconvolution
%% From NIFTI image (resting state fMRI data) to NIFTI image (HRF parameters).
%% Guo-Rong Wu, gronwu@gmail.com, UESTC, UGent, 2013.9.12
%% Reference: Wu, G.; Liao, W.; Stramaglia, S.; Ding, J.; Chen, H. & Marinazzo, D.. 
%% A blind deconvolution approach to recover effective connectivity brain networks 
%% from resting state fMRI data. Medical Image Analysis, 2013,17(3):365-374 .
clc,clear
%% Mask file
brainmask = 'E:\NYU_RS_LC\masks\MNI_brain_mask\rbrainmask.nii';%change the mask as you like
brain = spm_read_vols(spm_vol(brainmask));
data_tmp = zeros(size(brain));
voxel_ind = find(brain>0); %% change as you like.
num_voxel = length(voxel_ind);
nobs = 150; % number of time points
bsig = zeros(nobs,num_voxel); 

%% open Matlab parallel computing, NumWorkers: set a reasonable number yourself. If you don't have parallel facilities no prob, but change "parfor" to normal "for"
try 
    myCluster = parcluster('local');
    myCluster.NumWorkers = 8; 
    saveAsProfile(myCluster,'local2'); 
    matlabpool open 'local2' 8
end
TR = 2; %in seconds 
thr = 1; % threshold, for example 1 SD.
event_lag_max = 5; % the (estimated) maximum lagged time from neural event to BOLD event, in points. 


main= 'E:\NYU_RS_LC';  % data directory
data_dir = fullfile(main,'data_MNI'); %% where data are stored after smoothing,regression, filtering, detrending or whatever preprocessing
sub = dir(data_dir); 
sub(1:2)=[]; %this removes the "." and ".." 


BOLDpattern=fullfile('*task-rest_acq-normal_run-01_bold');
sessions={'ses-day1','ses-day2'};

save_dir = fullfile(main,'FunImgNor_HRF'); %% save dir, change the name as you like.
save_dir2 = fullfile(main,'FunImgNor_Deconv'); %% save dir, change the name as you like.

% make directories for the HRF parameters
mkdir(fullfile(save_dir,'Height'));
mkdir(fullfile(save_dir,'T2P'));
mkdir(fullfile(save_dir,'FWHM'));
mkdir(save_dir2);

for isub=1:length(sub)
    
    % read in the functional images 
    disp('Reading data ...')
    sub_dir = fullfile(data_dir,sub(isub).name);
    subjname=sub(isub).name;
    BOLD_dir=dir(fullfile(sub_dir,sessions{1},'func',BOLDpattern));
    BOLDim_path=fullfile(sub_dir,sessions{1},'func',BOLD_dir.name);
    BOLDim=dir(fullfile(BOLDim_path,['swu' subjname '*']));
    func_ims={BOLDim.name}';
    func_ims=func_ims(6:end);
    
    
    disp(sub(isub).name)
    cd(BOLDim_path);
    clear imag
    % if your preprocessed data are not stored in an image, but in a
    % vector, you can call this vector rsig and skip the following lines
    imag = dir('*.nii'); %% if *.nii, change it yourself.

    
    % Insert temporal mask - based on FWD threshold 0.2mm 
    disp('making temporal mask...') 
   
    % Load in final_regressors "final_regressors.mat"
    load(fullfile(BOLDim_path, 'log','final_regressors.mat'));
    R=R(:,27:32);

   % Get the FWD
    cutoff_fwd=0.2; % find out what is the cut off
    [fwd,rms]=bramila_framewiseDisplacement(R); % get fwd values
    scrubbing_bool = fwd>cutoff_fwd;
    
    bool_int ={};
    % remove image that > fwd threshold 
    for bool=1:numel(scrubbing_bool)
        
        if scrubbing_bool(bool)==1
            bool_int=[bool_int, bool];
            bool_int_mat=cell2mat(bool_int)';
        end
    end
    
    for int=bool_int_mat
        imag(int) = [];
    end
  
    
    tic
    rsig = zeros(size(imag,1),num_voxel);
    parfor k = 1:length(imag)
        [data1] = spm_read_vols(spm_vol(imag(k).name));
        rsig(k,:) =  data1(voxel_ind);
    end
    toc
    disp('Done') 
    
%     tic
%     rsig = spm_detrend(rsig,3); % make sure stability
%     toc
%     disp('Finishing detrending')   
    disp('Retrieving HRF ...'); 
    tic
        [data_deconv onset hrf event_lag PARA] = wgr_deconv_canonhrf_par(rsig,thr,event_lag_max,TR)
    toc
    disp('Done');   
    
    save(fullfile(save_dir,[sub(isub).name,'_hrf.mat']),'event_lag_max','thr','TR','onset', 'hrf','event_lag', 'PARA','-v7.3');
    
    
    % Write HRF parameter
    % Height - h
    % Time to peak - p (in time units of TR seconds)
    % FWHM (at half peak) - w  

    v=spm_vol(brainmask);
    v.dt=[16,0]; 
    
    v.fname = fullfile(save_dir,'Height',[sub(isub).name,'_height.nii']);
    data = data_tmp;
    data(voxel_ind)=PARA(1,:);
    spm_write_vol(v,data);

    v.fname = fullfile(save_dir,'T2P',[sub(isub).name,'_Time2peak.nii']);
    data = data_tmp;
    data(voxel_ind)=PARA(2,:);
    spm_write_vol(v,data);

    v.fname = fullfile(save_dir,'FWHM',[sub(isub).name,'_FWHM.nii']);
    data = data_tmp;
    data(voxel_ind)=PARA(3,:);
    spm_write_vol(v,data);
    
    
    sub_save_dir = fullfile(save_dir2,sub(isub).name);
    mkdir(sub_save_dir)
    % writting back into nifti files
    for k = 1:length(imag)
        v.fname = fullfile(sub_save_dir,imag(k).name);
        data = data_tmp;
        data(voxel_ind) = data_deconv(k,:);
        spm_write_vol(v,data);
    end   
    
    
    RH_z=zscore(PARA(1,:)); % zscore the time to peak
    RH_mean=mean(RH_z);
    TTP_mean=mean(PARA(2,:));   % in seconds
    FWHW_mean=mean(PARA(3,:));   % in seconds
    
    LC_hrf = [RH_mean*bf(:,1)+TTP_mean*bf(:,2)+FWHW_mean*bf(:,3)]; 

    plot(LC_hrf)
end
