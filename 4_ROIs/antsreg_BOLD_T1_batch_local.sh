#!/bin/sh

# ANTS
# antsreg_BOLD_T1_batch_local.sh
#  
#
#  Created by Beth Lloyd on 2/17/21.
#
# type in terminal:
# sh antsreg_BOLD_T1_batch_local.sh


# SETTINGS
#-----------------------------------------------------------------------------------
export ANTSPATH=/opt/ANTs/bin
export PATH=${ANTSPATH}:$PATH
export NYU_RS_LC_PATH=/Volumes/Littledrive/NYU_RS_LC
# make for loop over subjects

# define subject name
#SUBJNAME=001
    # day=2
    # for file in ${NYU_RS_LC_PATH}/data/*
    # do
        # export SUBJNAME="$(basename "${file: -3}")"
        # echo $SUBJNAME
    # define subject FSE path
    mean_EPI_path=/Volumes/Littledrive/NYU_RS_LC/data/MRI_FCWML${SUBJNAME}/ses-day1/anat/meanEPI/sub-MRIFCWML${SUBJNAME}_ses-day1_task-rest_acq-normal_run-01_bold
    all_EPI_path=/Volumes/Littledrive/NYU_RS_LC/data/MRI_FCWML${SUBJNAME}/ses-day${day}/func/sub-MRIFCWML${SUBJNAME}_ses-day${day}_task-rest_acq-normal_run-01_bold
    
    # define subject t1 path
    t1_path=/Volumes/Littledrive/NYU_RS_LC/data/MRI_FCWML${SUBJNAME}/ses-day2/anat/sub-MRIFCWML${SUBJNAME}_ses-day2_acq-highres_run-02_T1w
    tranforms_PATH=/Volumes/Littledrive/ANTs/step2_TemplateMultivariateSyN
# STEP 1: rigid + affine registration from mean EPI --> T1 (within subjs)
# DOESN'T WORK  ---------------------------------------------------------------------------------------
# run native space rigid+affine coreg between fse and t1
# PATH SETTINGS
# fixed_image=${t1_path}/MRI_FCWML${SUBJNAME}_0001.nii
# moving_image=${mean_EPI_path}/umeansub-MRI_FCWML${SUBJNAME}.nii
# output=${mean_EPI_path}/aff_

# run antsRegistrationSyN script
#antsRegistrationSyN.sh -d 3 -t a -f $fixed_image -m $moving_image -o $output

# STEP 2:pply transformation onto EPI image (T1 native -> T1 template transforms)
# ---------------------------------------------------------------------------------------
# apply transformation matrices (ouput registration) onto ROI masks
# GET FILES
        # for file in ${all_EPI_path}/*.nii
        # do
            # func_im="$(basename "${file: }")"
            # input_image=${all_EPI_path}/${func_im}

            # reference_image=/Volumes/Littledrive/ANTs/step1_TemplateMultivariateSyN/reT_template0.nii
            # output=${all_EPI_path}/aff_${func_im}

            # transformation=${tranforms_PATH}/warped_MRI_FCWML${SUBJNAME}_00010GenericAffine.mat
        # run antsApplyTransforms script
                #antsApplyTransforms -d 3 -i $input_image -r $reference_image -o $output -n Linear -t $transformation --verbose
        # done
    
    # done




## ROI transforms ----------------------------------------------------
# (MNI 2 template space transforms)

ROI_mni_path=/Volumes/Littledrive/NYU_RS_LC/masks

# define each mask
DR=${ROI_mni_path}/dorsal_raphne/raphe_masks/raphe_masks/dr.mask.ICBM152.brainstem.flirt.nii
MR=${ROI_mni_path}/dorsal_raphne/raphe_masks/raphe_masks/mr.mask.ICBM152.brainstem.flirt.nii

SN_l=${ROI_mni_path}/SN/atlas-sn_hem-l_mask-105_mni09b.nii
SN_r=${ROI_mni_path}/SN/atlas-sn_hem-r_mask-105_mni09b.nii

VTA_l=${ROI_mni_path}/VTA/atlas-vta_hem-l_mask-27_mni09b.nii
VTA_r=${ROI_mni_path}/VTA/atlas-vta_hem-r_mask-27_mni09b.nii

# choose mask to run
ROI_im=$DR
ROI_name='DR_mask'
input_image=${ROI_im}

# choose reference image (template im voxel or func im voxel size)
reference_image_re=/Volumes/Littledrive/ANTs/step1_TemplateMultivariateSyN/reT_template0.nii
reference_image=/Volumes/Littledrive/ANTs/step1_TemplateMultivariateSyN/T_template0.nii

# choose output folder and name
output_re=${ROI_mni_path}/Template_space_masks/reT_template0_${ROI_name}.nii
output=${ROI_mni_path}/Template_space_masks/T_template0_${ROI_name}.nii

transformation=/Volumes/Littledrive/ANTs/MNI_template/warped_MNI2Template0GenericAffine.mat

# run antsApplyTransforms script
antsApplyTransforms -d 3 -i $input_image -r $reference_image_re -o $output_re -n Linear -t $transformation --verbose

