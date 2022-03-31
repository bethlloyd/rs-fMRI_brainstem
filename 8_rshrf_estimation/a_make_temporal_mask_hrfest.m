function [temp_mask] = a_make_temporal_mask_hrfest(SUBJNAME,session)

% MAKE BOOLEAN TO INCLUDE AS TEMPORAL MASK IN HRF ESTIMATION BATCH
%--------------------------------------------------------------------------
% author: BL 2021

% PATH SETTINGS
%--------------------------------------------------------------------------


%path settings
%padi=i_fcwml_infofile(SUBJNAME);

main= 'F:\NYU_RS_LC';  % data directory
data_dir = fullfile(main,'data');
BOLDpattern=fullfile('*task-rest_acq-normal_run-01_bold');
sessions={'ses-day1','ses-day2'};
sub_dir=fullfile(data_dir, SUBJNAME);
%get log dir
BOLD_dir=dir(fullfile(sub_dir,sessions{session},'func',BOLDpattern));
BOLDim_path=fullfile(sub_dir,sessions{session},'func',BOLD_dir.name);

% Load in final_regressors "final_regressors.mat"
load(fullfile(BOLDim_path, 'log','final_regressors.mat'));
R=R(:,27:32);

% Get the FWD
cutoff_fwd=0.3; % find out what is the cut off
[fwd,rms]=bramila_framewiseDisplacement(R); % get fwd values
scrubbing_bool = fwd>cutoff_fwd;

temporal_mask_bool = scrubbing_bool==0;
temp_mask = [temporal_mask_bool];

savedir=fullfile(BOLDim_path, 'log','temporal_mask');
%mkdir
if ~exist(savedir, 'dir')
    mkdir(savedir)
end

%save(fullfile(savedir, 'temporal_mask_hrf_est.mat'),'temp_mask');


