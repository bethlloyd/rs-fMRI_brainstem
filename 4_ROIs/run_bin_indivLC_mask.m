clc
clear all

%% Path settings ----------------------------------------------------------
home='E:\NYU_RS_LC\';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));


for c_subj=1:72
    subjlist(c_subj).name
    SUBJNAME =subjlist(c_subj).name;
    SUBJNAMEcbi=erase(SUBJNAME,'_');
    load batch_binary_indiv_LCmask

     %change subject code
    matlabbatch = struct_string_replace(matlabbatch,'MRI_FCWML001',char(subjlist(c_subj).name));

    %run batch
    spm_jobman('run',matlabbatch); clear matlabbatch
    
    
end