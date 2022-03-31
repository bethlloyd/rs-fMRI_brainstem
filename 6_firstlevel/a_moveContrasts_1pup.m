function a_moveContrasts_1pup(SUBJNAME,pup_type)

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
models={'DR_roi', 'MR_roi', 'LC_roi', 'VTA_roi', 'SN_roi', 'ACC_roi', 'OCC_roi', 'BF_sept_roi', 'BF_subl_roi'};
%models={'P1', 'P2', 'P3', 'P4', 'P5'};
%models={'P2'};
smoothed = {'smoothed', 'unsmoothed'};

if pup_type == 1
    pup_vec = 'pup_size';
elseif pup_type == 2
    pup_vec = 'pup_deriv';
end
% 
% if session == 1
%     sess = 'ses-day-1';
% elseif session == 2
%     sess = 'ses-day-2';
% end

%datapaths
%path settings
homepath='F:';
projectpath=fullfile(homepath,'NYU_RS_LC');

for sm=1:numel(smoothed)
    for mod = 8:9%1:numel(models)
        datapath=fullfile(projectpath,'stats', 'template_1st_level_pipelines', smoothed{sm}, models{mod});
        savepath=fullfile(datapath,'groupstats', pup_vec);
        
        %make dir
        warning off;mkdir(savepath);warning on;
        
        %loop over contrast to extract the name 
        %positive constrasts
        contrastnames{1}=['T_pos1'];

        %negative constrasts
        contrastnames{2}=['T_neg1'];
        

        %get number of contrasts: 
        condir=fullfile(datapath, char(SUBJNAME), pup_vec);
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
end




    



