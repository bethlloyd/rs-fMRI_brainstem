function TotalReadoutTime = a_get_TotalReadoutTime(dicomfile)

%get the read out time from a DICOM file
%
% - this is used for Calculate VDM in SPM
% - input: a EPI dicom fle
% - output: Total EPI readout time in ms (as to be entered in SPM)
%
% based on following formula:
%   EffectiveEchoSpacing = 1/[BWPPPE * ReconMatrixPE]
%   TotalReadoutTime = EffectiveEchoSpacing * (ReconMatrixPE) = ReconMatrixPE/[BWPPPE * ReconMatrixPE] = 1/BWPPE
%   See: https://bids.neuroimaging.io/bids_spec.pdf
%
% LdV 2019

%read in file
dcminfo=dicominfo(dicomfile);

%calculate BandwidthPerPixelPhaseEncode (BWPPE)
BWPPE=typecast(int8(dcminfo.Private_0019_1028),'double');

%calculate read out time
TotalReadoutTime = (1/BWPPE)*1000;