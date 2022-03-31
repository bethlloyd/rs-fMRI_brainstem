function FWD = run_bramila_framewiseDisplacement(SUBJNAME, session)




%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end

%path settings
padi=i_fcwml_infofile(SUBJNAME);
homeD='D:\NYU_RS_LC\data';

%get the BOLD images that are in the subject folder
BOLD_dir=dir(fullfile(homeD,SUBJNAME,padi.sessions{session},'func',padi.BOLDpattern));
inputim.path=fullfile(homeD,SUBJNAME,padi.sessions{session},'func',BOLD_dir.name);
% Load in final_regressors "final_regressors.mat"
load(fullfile(inputim.path, 'log','final_regressors.mat'));
R=R(:,27:32);


% Get the FWD
cutoff_fwd=0.2; % find out what is the cut off
[fwd,rms]=bramila_framewiseDisplacement(R); % get fwd values

FWD  = mean(fwd);

% Make for each scan that has a fwd above the cut off a seperate regressor
scrubbing_bool = fwd>cutoff_fwd;
spikes = find(fwd>cutoff_fwd);
spikereg_matrix=zeros(length(scrubbing_bool),sum(scrubbing_bool));


for i=1:numel(spikes)
    
    spikereg_matrix(spikes(i),i)=1;
    
end

if sum(sum(spikereg_matrix,2)==scrubbing_bool)~=length(fwd)
    error('someting went wrong')
end



% save spikereg_matrix as a .mat file in log directory