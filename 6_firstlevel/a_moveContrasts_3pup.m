function a_moveContrasts_3pup(SUBJNAME,pup_type)

%--------------------------------------------------------------------------
%
% Move contrast images
%
%--------------------------------------------------------------------------
%get SUBJNAME
if ~exist('SUBJNAME')
    MRI_FCWML001=char(inputdlg('Which subject?'));
end

% SETTINGS
%--------------------------------------------------------------------------
%load paths
padi=i_fcwml_infofile(SUBJNAME);
SUBJNAMEcbi=erase(SUBJNAME,'_');


%taskname
pipeline_name='replication_methods';

if pup_type == 1
    pup_vec = 'pup_size';
elseif pup_type == 2
    pup_vec = 'pup_deriv';
end

% if session == 1
%     sess = 'ses-day-1';
% elseif session == 2
%     sess = 'ses-day-2';
% end

%datapaths
%path settings
homepath='E:';
Cpath='C:';
Dpath='D:';
projectpath=fullfile(Dpath,'NYU_RS_LC');
datapath=fullfile(projectpath,'stats', 'template_1st_level_pipelines', 'smoothed', pipeline_name);



savepath=fullfile(datapath,'groupstats', pup_vec);

%make dir
warning off;mkdir(savepath);warning on;


%loop over contrast to extract the name 
%positive constrasts
contrastnames{1}=['T_pos1'];
contrastnames{2}=['T_pos2'];
contrastnames{3}=['T_pos3'];

%negative constrasts
% contrastnames{4}=['T_neg1'];
% contrastnames{5}=['T_neg2'];
% contrastnames{6}=['T_neg3'];


%get number of contrasts: 
condir=fullfile(datapath, char(SUBJNAME), pup_vec);
conlist=dir(fullfile(condir,  'con*'));

%loop over subjects
%for ss=1:numel(subjdirs)
    
     %get contrast images
con_nii=conlist;
    %con_nii=[con_nii; dir(fullfile(datapath,SUBJNAME,'spmF*.nii'))];
    
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

    



