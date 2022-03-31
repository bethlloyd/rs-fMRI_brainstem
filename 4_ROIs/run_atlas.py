# -*- coding: utf-8 -*-


import nighres

import os

import nibabel as nb 




IMCN_template_mni09 = '/home/atrutti1/Documents/atlas-vta_mni09b/templates/mni09b/ahead_final_med_r1map_n104_mni09b.nii.gz'

IMCN_atlas_left = '/home/atrutti1/Documents/atlas-vta_mni09b/structures/mni09b/atlas-vta_hem-l_mask-27_mni09b.nii.gz'

IMCN_atlas_right = '/home/atrutti1/Documents/atlas-vta_mni09b/structures/mni09b/atlas-vta_hem-r_mask-27_mni09b.nii.gz'




out_dir = '/home/atrutti1/Documents/vta_atlases/mni09b'




Pauli_atlas_template = '/home/atrutti1/Documents/vta_atlases/Pauli2018/CIT168_T1w_700um.nii.gz'

Murty_atlas_template = '/home/atrutti1/Documents/vta_atlases/AdcockLab/Midbrain_Atlases/group_average.nii.gz'




Pauli_atlas = '/home/atrutti1/Documents/vta_atlases/Pauli2018/prob-atlas-vta/vol0010.nii.gz'

Murty_atlas_left = '/home/atrutti1/Documents/vta_atlases/AdcockLab/Midbrain_Atlases/mean_VTA-L.nii.gz'

Murty_atlas_right = '/home/atrutti1/Documents/vta_atlases/AdcockLab/Midbrain_Atlases/mean_VTA-R.nii.gz'




#Murty_atlas = 




#transformation_mtrx = '/home/atrutti1/Documents/vta_atlases/mni09b/atlas-template_Pauli-to-MNI09b_ants-map.nii.gz'







# register Pauli atlas to IMCN group MNI09b template 




# co-register wb templates 

ants_output = nighres.registration.embedded_antsreg(

source_image= Pauli_atlas_template,

target_image= IMCN_template_mni09,

run_rigid=True, run_affine=True, run_syn=True, 

save_data=True, file_name="atlas-template_Pauli-to-MNI09b",

output_dir=out_dir, overwrite=True)




# #fix header (there was a header issue that lead to misalignment when doing it the)

# tpl_img = nighres.io.load_volume('/home/atrutti1/Documents/vta_atlases/mni09b/atlas-template_Pauli-to-MNI09b_ants-def0.nii.gz')

# atl_img = nighres.io.load_volume(Pauli_atlas)

# atl_img = nb.Nifti1Image(atl_img.get_fdata(), tpl_img.affine, tpl_img.header)




template_map = '/home/atrutti1/Documents/vta_atlases/mni09b/atlas-template_Pauli-to-MNI09b_ants-map.nii.gz'




# deformed_output = nighres.registration.apply_coordinate_mappings(

# image = atl_img, 

# mapping1 = ants_output['mapping'],

# save_data = True,

# file_name = 'atlas-vta_Pauli-to-MNI09b',

# output_dir=out_dir,overwrite=True

# )







deformed_output = nighres.registration.apply_coordinate_mappings(

image = Pauli_atlas, #atl_img, 

mapping1 = template_map, #ants_output['mapping'],

save_data = True,

file_name = 'atlas-vta_Pauli-to-MNI09b',

output_dir=out_dir,overwrite=True

)







#thresholded atlas

deformed_output = nighres.registration.apply_coordinate_mappings(

image = Pauli_atlas, #atl_img, 

mapping1 = template_map, #ants_output['mapping'],

save_data = True,

file_name = 'atlas-vta_Pauli-to-MNI09b',

output_dir=out_dir,overwrite=True

)













# more midbrain nuclei

Pauli_pbp = '/home/atrutti1/Documents/vta_atlases/Pauli2018/prob-atlas-pbp/vol0009.nii.gz'

Pauli_snr = '/home/atrutti1/Documents/vta_atlases/Pauli2018/prob-atlas-snr/vol0008.nii.gz'

Pauli_snc = '/home/atrutti1/Documents/vta_atlases/Pauli2018/prob-atlas-snc/vol0006.nii.gz'







deformed_output_pbp = nighres.registration.apply_coordinate_mappings(

image = Pauli_pbp, #atl_img, 

mapping1 = template_map, #ants_output['mapping'],

save_data = True,

file_name = 'atlas-pbp_Pauli-to-MNI09b',

output_dir=out_dir,overwrite=True

)

deformed_output_snr = nighres.registration.apply_coordinate_mappings(

image = Pauli_snr, #atl_img, 

mapping1 = template_map, #ants_output['mapping'],

save_data = True,

file_name = 'atlas-snr_Pauli-to-MNI09b',

output_dir=out_dir,overwrite=True

)




deformed_output_snc = nighres.registration.apply_coordinate_mappings(

image = Pauli_snc, #atl_img, 

mapping1 = template_map, #ants_output['mapping'],

save_data = True,

file_name = 'atlas-snc_Pauli-to-MNI09b',

output_dir=out_dir,overwrite=True

)




# register Murty atlas to IMCN group MNI09b template

ants_output2 = nighres.registration.embedded_antsreg(

source_image= Murty_atlas_template,

target_image= IMCN_template_mni09,

run_rigid=True, run_affine=True, run_syn=True, 

save_data=True, file_name="atlas-template_Murty-to-MNI09b",

output_dir=out_dir, overwrite=True)




deformed_output2 = nighres.registration.apply_coordinate_mappings(

image =Murty_atlas_left, 

mapping1 = ants_output2['mapping'],

save_data = True,

file_name = 'atlas-vta_hem-l_Murty-to-MNI09b',

output_dir=out_dir,overwrite=True

)




deformed_output3 = nighres.registration.apply_coordinate_mappings(

image =Murty_atlas_right, 

mapping1 = ants_output2['mapping'],

save_data = True,

file_name = 'atlas-vta_hem-r_Murty-to-MNI09b',

output_dir=out_dir,overwrite=True

)