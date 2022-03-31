function [Cxy_send,F_mscohere_send]=f_fcwml_crossSpectrum(SUBJNAME, pup_type, roi, session)


% get the denoised BOLD (concatonated then seperate)
% load in the pupil vectors
% perform cross-spectrum for each session

%% SETTINGS

%path settings
addpath('E:\NYU_RS_LC\scripts');
addpath('E:\NYU_RS_LC\scripts\0_general');
home_E = 'E:\NYU_RS_LC';
padi=i_fcwml_infofile(SUBJNAME);

% settings
formatSpec = '%f';
extrval=0.01;
%rng default
Window_length = 10;
no_overlap = 3;
Fs = 0.5;
%freqrange = 'twosided';


%% remove excluded subjects
subjexcl_d1={'MRI_FCWML004', 'MRI_FCWML016', 'MRI_FCWML025', 'MRI_FCWML043', 'MRI_FCWML044', 'MRI_FCWML055',... 
                'MRI_FCWML119', 'MRI_FCWML145', 'MRI_FCWML160', 'MRI_FCWML219'};
subjexcl_d2={'MRI_FCWML020', 'MRI_FCWML022', 'MRI_FCWML028', 'MRI_FCWML033', 'MRI_FCWML036', 'MRI_FCWML044', 'MRI_FCWML064',... 
                 'MRI_FCWML145'};
which_day = {subjexcl_d1, subjexcl_d2};                 
% residual data folder 
RES_dat = 'E:\NYU_RS_LC\stats\BS_correlations\smoothed';
% roi path
ROI_path = 'F:\NYU_RS_LC\masks\ROI_final';

size_len = 31;

if ismember(SUBJNAME, which_day{session})  
    
%     Cxy= NaN(1,len_F,'single');
%     F_mscohere= NaN(1,len_F,'single');
%     Pxy= NaN(1,len_F,'single');
%     F_cpsd= NaN(1,len_F,'single');
    Cxy = NaN(1,size_len,'single');
    F_mscohere= NaN(1,size_len,'single');
    Cxy_send = Cxy;
    
else
    % Load in RESIDUAL data
    inputim.path=fullfile(RES_dat,SUBJNAME,padi.sessions{session});

    BOLDim=dir(fullfile(inputim.path,['Res_*']));
    inputim.ims={BOLDim.name}';
    
     
    %BS roi path
    ROI_folder=dir(fullfile(ROI_path, [roi, '_roi'], ['*.nii']));
    ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
    % extract signal
    [sigextr_roi, roixyz] = f_extract_BOLD_data(inputim, ROI_mask,extrval);
    %sigextr_roi=sigextr_roi'-mean(sigextr_roi); % demean the signal

    
      % assign the BOLD signal 
    if session == 1
        sess = 'ses-day1';
        %BOLD_sig = HRF_dat.data(1:150,roi);
    elseif session == 2
        sess = 'ses-day2';
        %BOLD_sig = HRF_dat.data(151:300,roi);
    end
    
      %load in the pupil vectors
    pup_dir=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\rawdata\', ...
            SUBJNAME, ['logfiles-',sess], 'processed\smoothed\2_downsampled');

    if pup_type==1% Load in pupil regressor # 2 - Diameter
    % get correct folder
        pup_filename=['pupil_dilation.txt'];
        pupdat=fullfile(pup_dir, pup_filename);
        
         % open datafile
        fid=fopen(pupdat, 'r');
        pup_int = fscanf(fid,formatSpec);
        fclose(fid);
   
        
    elseif pup_type==2 % Load in pupil regressor # 2 - Derivative
        % get correct folder
        deriv_pup_filename=['pupil_derivative.txt'];
        deriv_pupdat=fullfile(pup_dir, deriv_pup_filename);
        
        fid1=fopen(deriv_pupdat, 'r');
        pup_int = fscanf(fid1,formatSpec);
        fclose(fid1);

    end
    
    %pup_int=pup_int'-mean(pup_int); % demean the signal
    pup_int= pup_int';
  
    [Cxy,F_mscohere] = mscohere(pup_int,sigextr_roi, Window_length, no_overlap, 60, Fs);

    Cxy_send = Cxy;
    F_mscohere_send = F_mscohere;
%     plot(F_mscohere,Cxy)
%     title('Magnitude-Squared Coherence')
%     xlabel('Frequency (Hz)')
%     grid
    
%     % Cross Spectrum 
    %[Pxy,F_cpsd] = cpsd(pup_int,sigextr_roi, Window_length, no_overlap, 60, Fs);
    %Pxy(Cxy < 0.2) = 0;
    %Pxy = angle(Pxy_orig);

    
%     plot(F_cpsd,angle(Pxy_orig)/pi)
%     title('Cross Spectrum Phase')
%     xlabel('Frequency (Hz)')
%     ylabel('Lag (\times\pi rad)')
%     grid
    
end

F_mscohere_send = F_mscohere;

