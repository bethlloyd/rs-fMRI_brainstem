function [r p]=f_fcwml_brainstem_Correlations(SUBJNAME,session)

% get the denoised BOLD (concatonated then seperate)
% perform correlation for each BS regions

home_E = 'E:\NYU_RS_LC';
data_dir = fullfile(home_E, 'stats', 'rsHRF');

% get the HRF struct 
HRF_file = fullfile(data_dir, SUBJNAME, 'concat', '1_canonical', ['Deconv_aff_u', SUBJNAME, '_0006.mat']);

HRF_dat  = load(HRF_file);

  % assign the BOLD signal 
if session == 1
    BOLD_sig = HRF_dat.data(1:150,:);
elseif session == 2
    BOLD_sig = HRF_dat.data(151:300,:);
end

DR_sig = BOLD_sig(:,1);
DR_sig=DR_sig'-mean(DR_sig);
MR_sig = BOLD_sig(:,2);
MR_sig=MR_sig'-mean(MR_sig);
VTA_sig = BOLD_sig(:,3);
VTA_sig=VTA_sig'-mean(VTA_sig);
LC_sig = BOLD_sig(:,5);
LC_sig=LC_sig'-mean(LC_sig);
SN_sig = BOLD_sig(:,6);
SN_sig=SN_sig'-mean(SN_sig);


BS_vecs = [LC_sig; VTA_sig; SN_sig; DR_sig; MR_sig];
BS_vecs = BS_vecs';
[r p]=corrcoef(BS_vecs);

