function [intensity] = a_extract_intensity_ROI(SUBJNAME)

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
padi=i_fcwml_infofile(SUBJNAME);
home='D:\NYU_RS_LC';
addpath('E:\NYU_RS_LC\scripts\0_general');
% Make save folder
savepath='D:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\stats\LC_mask\intensity_analysis';
%mkdir(fullfile(savepath,SUBJNAME));

maskDir = ('E:\NYU_RS_LC\masks\Template_space_masks');
%define ROI filenames

LC_ROI= fullfile(maskDir, 'hand-drawn_LC_template0_FSE.nii');
PONS_ROI=fullfile(maskDir, 'pontine_ref_ROI.nii');

ROIs = {LC_ROI, PONS_ROI};
% GET DATA
%--------------------------------------------------------------------------
    
%get the FSE images that are in the subject folder
FSE_dir=dir(fullfile(home,'ANTs','step3_*'));
FSEim=dir(fullfile(home,'ANTs', FSE_dir.name,['warped_FSE_' SUBJNAME 'Warped.nii']));
    
    
%loop over roi's
for c_roi=1:numel(ROIs)
        
  
    %get hdr of roi
    r_hdr=spm_vol(ROIs{c_roi});



    %get the beta map hdr
    c_hdr=spm_vol(fullfile(FSEim.folder,FSEim.name));

%             %check dimentions
%             if abs(sum(sum(c_hdr.mat-r_hdr.mat)))>0
%                 error('ROI and CONTRAST MAP are not in the same space!')
%             end

    %get roi coordinates
    roixyz{c_roi} = f_NYULC_threeDfind(r_hdr,1);

    %get number of voxels:
    %num_voxels=numel(spm_get_data(c_hdr,roixyz{c_roi}));

    %get the data from the images based on the ROI
    extracteddata(1,c_roi)=num2cell(mean(spm_get_data(c_hdr,roixyz{c_roi})));

    intensity=extracteddata;
end % roi


    
    % SAVE DATA
    %--------------------------------------------------------------------------
    %remove 2nd row (full of commas)
    %extracteddata{c_roi}(2,:) = [];
    %newroi_name=erase(roinames{c_roi}, '.nii');
    
% filename=strcat(padi.sessions{c_sess},'_extrsig_LC.csv');
% savefilename=fullfile(savepath, SUBJNAME,filename);
% cell2csv(savefilename,extracteddata{c_sess})



