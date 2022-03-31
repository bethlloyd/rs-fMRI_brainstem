function f_fcwml_calc_tsnr(SUBJNAME,SESSION)

%load paths
homeE='E:\NYU_RS_LC';
stats=fullfile(homeE, 'stats');
SUBJNAMEcbi=erase(SUBJNAME,'_');
session = {'ses-day1', 'ses-day2'};
%func path
padi.func=fullfile('D:\NYU_RS_LC\data', SUBJNAME, session{SESSION}, 'func', ['sub-',...
    SUBJNAMEcbi, '_', session{SESSION}, '_task-rest_acq-normal_run-01_bold']);

%create output dir
warning off
mkdir(fullfile(stats,'tsnr',SUBJNAME,session{SESSION}))
warning on

%get files
funcfiles=dir(fullfile(padi.func,'aff*'));
   
        
%make cell array
P=fullfile(padi.func,'/',{funcfiles.name})';

%run tsnr scripts
Q = f_calc_tsnr(P);

%move image
movefile(...
    Q,...
    fullfile(stats,'tsnr',SUBJNAME,session{SESSION},['tSNR_im.nii']))        



