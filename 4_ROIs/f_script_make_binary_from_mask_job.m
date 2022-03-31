%-----------------------------------------------------------------------
% Job saved on 25-Feb-2021 19:31:24 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {'E:\NYU_RS_LC\data\MRI_FCWML328\ses-day2\ROI\LC\overlap\rMRI_FCWML328_mask_regNat.nii,1'};
matlabbatch{1}.spm.util.imcalc.output = 'lcmask_regNat_binary.nii';
matlabbatch{1}.spm.util.imcalc.outdir = {'E:\NYU_RS_LC\data\MRI_FCWML328\ses-day2\ROI\LC\overlap'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1>0.2917';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
