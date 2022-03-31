function [con_stat] = a_extract_BOLD_data(SUBJNAME, smooth, pup_type)

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
addpath('E:\NYU_RS_LC\scripts');
addpath('E:\NYU_RS_LC\scripts\0_general');
padi=i_fcwml_infofile(SUBJNAME);

LC_native_stats = fullfile('D:\NYU_RS_LC\stats\template_1st_level_pipelines\', smooth,...
    '\LC_native_space');


%define ROI filenames
mask_filename=strcat('r', SUBJNAME,'_mask_regNat.nii');

% GET DATA
%--------------------------------------------------------------------------

%get the conmaps that are in the subject folder
con_dir=fullfile(LC_native_stats,SUBJNAME, pup_type);
conim=dir(fullfile(con_dir,'spmT_0001.nii'));

    
%loop over roi's
for c_roi=3%1:numel(padi.raters)
    
    rater = padi.raters{c_roi};

    %get hdr of roi
    r_hdr=spm_vol(fullfile(padi.LC_roi,padi.raters{c_roi}, mask_filename));

    
    %get the beta map hdr
    c_hdr=spm_vol(fullfile(conim.folder, conim.name));

    %check dimentions
    if abs(sum(sum(c_hdr.mat-r_hdr.mat)))>0
        error('ROI and CONTRAST MAP are not in the same space!')
    end

    %get roi coordinates
    roixyz{c_roi} = f_NYULC_threeDfind(r_hdr,0.1);

    %get number of voxels:
    num_voxels=numel(spm_get_data(c_hdr,roixyz{c_roi}));
    disp(['number voxels in mask is ', num2str(num_voxels)]);
       
    con_stat=num2cell(mean(spm_get_data(c_hdr,roixyz{c_roi})));


end % roi




