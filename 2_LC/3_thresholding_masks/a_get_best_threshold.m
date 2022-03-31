function qMM = a_get_best_threshold(SUBJNAME,c_rater)

% CALCULATE APPROPROATE THESHOLD FOR FINALISING LC MASK
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

% OTHER SETTINGS 
res_FSE=[0.43*0.43*3.5]; %0.43*0.43*3.5
res_EPI=[2*2*2]; %2*2*2

%original mask
orig_maskdir=padi.rater{c_rater};
if c_rater==1
    orig_mask_filename=[SUBJNAME '_0001.nii'];
elseif c_rater ==2
    orig_mask_filename=[SUBJNAME '_0001.nii'];
elseif c_rater==3
    orig_mask_filename='overlap_mask.nii';
end

 %get roi coordinates
roixyz = f_NYULC_threeDfind(fullfile(orig_maskdir, orig_mask_filename),.1);

% Calculate mm3
qMM=size(roixyz,2)*res_FSE;

