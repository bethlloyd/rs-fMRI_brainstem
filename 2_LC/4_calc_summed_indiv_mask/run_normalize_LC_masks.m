%% Path settings ----------------------------------------------------------
home='E:\NYU_RS_LC\';
subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));



% Loop over subjects
for c_subj = 1:72  %  !!! need to re-run subject 004 as a single session!
    %subjincl
    disp(['now running subj ', subjlist(c_subj).name]);


    a_normalize_LC_masks(subjlist(c_subj).name);
end