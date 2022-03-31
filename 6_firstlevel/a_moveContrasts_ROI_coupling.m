function a_moveContrasts_ROI_coupling(SUBJNAME)

%--------------------------------------------------------------------------
%
% Move contrast images
%
%--------------------------------------------------------------------------
%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end

addpath('E:\NYU_RS_LC\scripts');

% SETTINGS
%--------------------------------------------------------------------------
%load paths
padi=i_fcwml_infofile(SUBJNAME);
SUBJNAMEcbi=erase(SUBJNAME,'_');


%taskname
smoothed = {'smoothed', 'unsmoothed'};

%datapaths
%path settings
homepath='D:';
projectpath=fullfile(homepath,'NYU_RS_LC');

for sm=1
    
    datapath=fullfile(projectpath,'stats', 'template_1st_level_pipelines', smoothed{sm}, 'ROI_coupling');
    savepath=fullfile(datapath,'groupstats');

    %make dir
    warning off;mkdir(savepath);warning on;

    %loop over contrast to extract the name 
    %positive constrasts
    contrastnames{1}=['T_pos_LC'];
    contrastnames{2}=['T_pos_VTA'];
    contrastnames{3}=['T_pos_SN'];
    contrastnames{4}=['T_pos_DR'];
    contrastnames{5}=['T_pos_MR'];
    contrastnames{6}=['T_pos_all'];

    %get number of contrasts: 
    condir=fullfile(datapath, char(SUBJNAME));
    conlist=dir(fullfile(condir,  'con*'));

    %get contrast images
    con_nii=conlist;


    %loop over contrasts
    for c_con=1:numel(con_nii)

        %make dir
        warning off;mkdir(fullfile(savepath,contrastnames{c_con}));warning on;

        %copy file
        copyfile(...
            fullfile(condir,con_nii(c_con).name),...
            fullfile(savepath,contrastnames{c_con},...
            strcat(SUBJNAME,'_',con_nii(c_con).name))...
            );        

    end
    
end




    



