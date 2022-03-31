% make the temporal mask for each subj and session (to add to hrf
% estimation model)

clear all; clc;

% Settings
%subjpath='C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\data';
subjpath='E:\NYU_RS_LC\data';
subjlist=dir(fullfile(subjpath,'MRI*'));

% subject settings
%subjexcl_d1=[15, 21, 37, 38, 47, 57, 62, 66, 69];   % subjs to excl from analysis day1 (note they are linked to order in list)
%subjexcl_d2=[18, 19, 24, 29, 31, 38, 52];             % subjs to excl from analysis day2 --> need to look at number 31 (subj 36)! -- pup int half the length!
list_total=[1:72];

if ~exist('day')
    day=char(inputdlg('Which day?'));
end; % select day here!

% if day=='1'
%     subjincl=setdiff(list_total,subjexcl_d1);
%     disp(numel(subjincl));
% elseif day=='2'
%     subjincl=setdiff(list_total,subjexcl_d2);
%     disp(numel(subjincl));
% end

% Loop over subjects
for c_subj = 13
    subjlist(c_subj).name
   
    a_make_temporal_mask_hrfest(subjlist(c_subj).name,str2num(day));

end