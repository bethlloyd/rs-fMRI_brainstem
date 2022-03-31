function [z_score]=a_permutation_testing_fMRI_pup(SUBJNAME,session, pup_type)

% Permutation test on fMRI data w/pupil vector for each BS ROI

% PATH SETTINGS
%--------------------------------------------------------------------------
addpath('E:\NYU_RS_LC\scripts');
addpath('E:\NYU_RS_LC\scripts\0_general');

% set mask threshold
extrval=0.01;
formatSpec = '%f';

%Permutation
n_permutation=10000;

%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end

%path settings
padi=i_fcwml_infofile(SUBJNAME);

subjexcl_d1={'MRI_FCWML004', 'MRI_FCWML016', 'MRI_FCWML025', 'MRI_FCWML043', 'MRI_FCWML044', 'MRI_FCWML055',... 
                'MRI_FCWML119', 'MRI_FCWML145', 'MRI_FCWML160', 'MRI_FCWML219'};
subjexcl_d2={'MRI_FCWML020', 'MRI_FCWML022', 'MRI_FCWML028', 'MRI_FCWML033', 'MRI_FCWML036', 'MRI_FCWML044', 'MRI_FCWML064',... 
                 'MRI_FCWML145'};

which_session={subjexcl_d1, subjexcl_d2};

%define the BS ROIs 
ROI={'LC_roi'};%, 'VTA_roi', 'SN_roi', 'DR_roi', 'MR_roi'};
ROI_path = 'D:\NYU_RS_LC\Template_space_masks';


sess={'ses-day-1', 'ses-day-2'};

% residual data folder 
RES_dat = 'D:\NYU_RS_LC\stats\native_space_LC\unsmoothed\residuals';


if ismember(SUBJNAME, which_session{session})  
    z_score = NaN(1,1,'single');
else

    % Get RESIDUAL data file names
    inputim.path=fullfile(RES_dat,sess{session},SUBJNAME);
    BOLDim=dir(fullfile(inputim.path,['Res_*']));
    inputim.ims={BOLDim.name}';



    %for c_roi = 1:numel(ROI)

    disp(['...running subject: ', SUBJNAME]);
    % load in PUPIL data
    pup_dir=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\rawdata\', ...
                SUBJNAME, ['logfiles-' padi.sessions{session}], 'processed\smoothed\3_convolved\HRF_ROIs');

    if pup_type==1 % Load in pupil regressor # 2 - Diameter
        % get correct folder
        pup_filename=['pupil_dilation_LC_roi.txt'];
        pupdat=fullfile(pup_dir, pup_filename);
         % open datafile
        fid=fopen(pupdat, 'r');
        pup_int = fscanf(fid,formatSpec);
        fclose(fid);
        savedir='pup_size';

    elseif pup_type==2 % Load in pupil regressor # 2 - Derivative
        % get correct folder
        deriv_pup_filename=['pupil_derivative_LC_roi.txt'];
        deriv_pupdat=fullfile(pup_dir, deriv_pup_filename);
          % open datafile
        fid1=fopen(deriv_pupdat, 'r');
        pup_int = fscanf(fid1,formatSpec);
        fclose(fid1);
        savedir='pup_deriv';
    end


    % Load in fMRI RESIDUAL data
    
    ROI_folder=dir(fullfile('E:\NYU_RS_LC\data\', SUBJNAME, '\ses-day2\ROI\LC\overlap\', ['*regNat_binary.nii']));
    ROI_mask=fullfile(ROI_folder.folder, ROI_folder.name);
    
    % extract signal
    [sigextr_roi, roixyz] = f_extract_BOLD_data(inputim, ROI_mask,extrval);
    sigextr_roi=sigextr_roi'-mean(sigextr_roi); % demean the signal
    if size(roixyz,2) < 1
        z_score = NaN(1,1,'single');
    else
        % Original correlation
        orig_corr = corr(sigextr_roi,pup_int);

        % Do the permutation by shuffeling the pupil vector
        perm_corrs = [];
        for c_perm = 1:n_permutation

            %shuffle pupil
            shuffle_pup = pup_int(randperm(numel(pup_int)));

        %correlate
        perm_corrs(c_perm) = corr(sigextr_roi,shuffle_pup);

        end

        % Obtain the z-value for the original correlation in its own
        % distribution
        z_score = (orig_corr - mean(perm_corrs)) / std(perm_corrs);
        
        
        % check for >1.96 any subjs
    end

   
end
