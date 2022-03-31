clear all;clc;

datapath='E:\NYU_RS_LC\data';
subjdirs=dir(fullfile(datapath,'MRI*'));

aMM_all=[];
closest_qMM=[];
pos_mm3_dim=[8,16,24,32,40];

% OTHER SETTINGS 
res_FSE=[0.43*0.43*3.5]; %0.43*0.43*3.5
res_EPI=[2*2*2]; %2*2*2

for c_rat=1:3
    
    for c_subj =1:numel(subjdirs)
        aMM_all(c_subj,c_rat) = a_get_best_threshold(subjdirs(c_subj).name,c_rat);
        
        diff=abs(pos_mm3_dim- aMM_all(c_subj,c_rat));
        closest_qMM(c_subj,c_rat) = pos_mm3_dim(diff==min(diff));
       
    end
end

% from here only use overlap masks 
aMM_overlap=aMM_all(:, 3);
closest_MM_overlap=closest_qMM(:,3); 
 
%get number of equivelant voxels in EPI space
nvox_EPI=closest_MM_overlap/res_EPI;
 
for c_subj =1:numel(subjdirs)
    
     %path settings
    padi=i_fcwml_infofile(subjdirs(c_subj).name);
    maskdir=padi.rater{3};% overlap dir
    
    % get number of equivelat EPI voxels 
    subj_nvox_EPI=nvox_EPI(c_subj);
     
    % get resliced mask 
    reslice_mask_filename=strcat('r', subjdirs(c_subj).name, '_mask_regNat.nii');
    
    %get roi coordinates (aka number of voxels from resliced mask)
    roixyz = f_NYULC_threeDfind(fullfile(maskdir, reslice_mask_filename),.01);
    c_hdr=spm_vol(fullfile(maskdir, reslice_mask_filename));
    values_vol=sort(spm_get_data(c_hdr,roixyz),'descend');
    
    %apply new threshold to get the correct number of voxels
    new_threshold=values_vol(subj_nvox_EPI);
    roixyz_fin = f_NYULC_threeDfind(fullfile(maskdir, reslice_mask_filename),new_threshold);
    
    
% change inputs for batch
    load f_make_binary_from_mask_batch

    %change subject code
    matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(subjdirs(c_subj).name));
    %matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML001',char(SUBJNAMEcbi));

    matlabbatch{1}.spm.util.imcalc.expression = ['i1>=' num2str(new_threshold-.001)];
    
    %run batch
    spm_jobman('run',matlabbatch); clear matlabbatch
end
 
