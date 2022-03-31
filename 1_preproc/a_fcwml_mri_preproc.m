function a_fcwml_mri_preproc(SUBJNAME)

%--------------------------------------------------------------------------
%
% perform preproc steps for FCWML
%
%LdV 2019
%--------------------------------------------------------------------------

%get SUBJNAME
if ~exist('SUBJNAME')
    SUBJNAME=char(inputdlg('Which subject?'));
end


% PARAMETERS
%--------------------------------------------------------------------------
%load paths
padi=i_fcwml_infofile(SUBJNAME);
SUBJNAMEcbi=erase(SUBJNAME,'_');

% LOAD BATCH - NATIVE SPACE [field map correction]
%--------------------------------------------------------------------------
load f_fcwml_mri_fmapcorr

%change subject code
matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML005',char(SUBJNAME));
matlabbatch = struct_string_replace(matlabbatch,'MRIFCWML005',char(SUBJNAMEcbi));

% TEST!!!!
matlabbatch = struct_string_replace(matlabbatch,'P:\Linda\projects\','C:\work\NYU\');

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch

%clean up
for c_sess = 1:2

    %save mean EPI
    meanEPIdir=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},...
        'anat','meanEPI',padi.sessions{c_sess});
    mkdir(meanEPIdir)
    
    %get func dirs
    funcdirs=dir(fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func','*bold'));    
    
    for c_dirs=2:numel(funcdirs)

        %go to dir
        curdir=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func',funcdirs(c_dirs).name);    
        cd(curdir)

        %move
        if c_sess == 1 && c_dirs == 2
            movefile(['meanu',SUBJNAME,'_0001.nii'],...
                fullfile(meanEPIdir,['meanu',SUBJNAME,'_0001.nii']))
        end
        
        %delete
        delete(['rp_',SUBJNAME,'_0001.txt'])
        delfiles=dir([SUBJNAME '*.nii']);
        for c_fls=1:numel(delfiles)
            delete(delfiles(c_fls).name);
        end

    end

end

% LOAD BATCH - NATIVE SPACE [coregistration]
%--------------------------------------------------------------------------

%mean image
padi.meanEPI=fullfile(padi.data,SUBJNAME,padi.sessions{1},...
        'anat','meanEPI',padi.sessions{1},['meanu',SUBJNAME,'_0001.nii']);

%all functional images day 1 and day 2
funcfilesall=[];
for c_sess = 1:2
    
    %functional
    funcdirs=dir(fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func','*bold'));
    for c_dirs=2:numel(funcdirs)
        
        %get nii files for that run
        currdir=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func',funcdirs(c_dirs).name);
        funcfiles=cellstr(spm_select('List',[currdir],['^*u.*\.nii']));
        funcfilesall=[funcfilesall;strcat(currdir,'/',funcfiles)];
    
    end
    
    %mean images
    meanEPIdirs=dir(fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'anat','meanEPI','*bold'));
    for c_dirs=1:numel(meanEPIdirs)
        
        %get nii files for that run
        currdir=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'anat','meanEPI',meanEPIdirs(c_dirs).name);
        meanEPIfiles=cellstr(spm_select('List',[currdir],['^u.*\.nii']));
        funcfilesall=[funcfilesall;strcat(currdir,'/',meanEPIfiles)];
    
    end  
    
end

%load batch
load f_fcwml_mri_coreg

%chaneg input
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {padi.T1}; %anat
matlabbatch{1}.spm.spatial.coreg.estimate.source = {padi.meanEPI}; %meanEPI
matlabbatch{1}.spm.spatial.coreg.estimate.other = funcfilesall; %func scans

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch
    



% LOAD BATCH - MNI [normalize and smooth]
%--------------------------------------------------------------------------
%all functional images day 1 and day 2
funcfilesall=[];
for c_sess = 1:2
    
    %functional
    funcdirs=dir(fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func','*task-TASK*'));
    
    for c_dirs=2:numel(funcdirs)
        
        %get nii files for that run
        currdir=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func',funcdirs(c_dirs).name);
        funcfiles=cellstr(spm_select('List',[currdir],['^*u.*\.nii']));
        funcfilesall=[funcfilesall;strcat(currdir,'/',funcfiles)];
    
    end
    
end

%load batch
load f_fcwml_mri_normsmoo

%change input
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {padi.T1}; %anat
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = funcfilesall; %func scans

%run batch
spm_jobman('run',matlabbatch); clear matlabbatch


% REORGANIZE AND CLEAN UP
%--------------------------------------------------------------------------

%tsnr image for native space and MNI/smoothed images
for c_sess = 1:2
    f_fcwml_calc_tsnr(SUBJNAME,'uMRI*.nii',0,c_sess)
    f_fcwml_calc_tsnr(SUBJNAME,'swuMRI*.nii',1,c_sess)
end

%remove 'wu' files [to save space and we do not need these]
for c_sess = 1:2
    
    funcdirs=dir(fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func','*task-TASK*'));
    
    for c_dirs=2:numel(funcdirs)

        %go to dir
        curdir=fullfile(padi.data,SUBJNAME,padi.sessions{c_sess},'func',funcdirs(c_dirs).name);    
        cd(curdir)

        %delete
        delfiles=dir('wuMRI_FCWML*.nii');
        for c_fls=1:numel(delfiles)
            delete(delfiles(c_fls).name);
        end

    end
end