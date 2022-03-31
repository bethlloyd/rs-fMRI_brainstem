SUBJNAME = 'MRI_FCWML029';
formatSpec = '%f';

HRF = load(['Deconv_aff_u', SUBJNAME, '_0006.mat']);

HRF_info = load(['Deconv_aff_u', SUBJNAME, '_0006_hrf.mat']);


pup_dir_d1=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\rawdata\', ...
            SUBJNAME, ['logfiles-ses-day1'], 'processed\smoothed\3_convolved\HRF_canonical');
pup_dir_d2=fullfile('C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\rawdata\', ...
    SUBJNAME, ['logfiles-ses-day2'], 'processed\smoothed\3_convolved\HRF_canonical');
pup_filename=['pupil_dilation_canonical_P5.txt'];
pupdat1=fullfile(pup_dir_d1, pup_filename);
pupdat2=fullfile(pup_dir_d2, pup_filename);
 % open datafile
fid=fopen(pupdat1, 'r');
pup_int_d1 = fscanf(fid,formatSpec);
fclose(fid);
fid=fopen(pupdat2, 'r');
pup_int_d2 = fscanf(fid,formatSpec);
fclose(fid);

pup_both = [pup_int_d1; pup_int_d2];

pup_z=zscore(pup_both);




LC_rawdata= zscore(HRF.data(:,5));
plot(LC_rawdata, 'LineWidth',2.0); hold on
%plot(pup_z); hold on 
yline(1,'--');
exportgraphics(gcf,'vectorfig.eps','ContentType','vector');