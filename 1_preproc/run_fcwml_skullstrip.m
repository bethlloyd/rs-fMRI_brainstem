function run_fcwml_skullstrip()

% Settings
subjpath='E:\NYU_RS_LC\data';

subjlist=dir(fullfile(subjpath,'MRI*'));
list_total=[1:72];
subjexcl_d1=[4, 15, 21, 37, 38, 47, 57, 62, 66, 69];
subjexcl_d2=[18, 19, 24, 29, 31, 38,  52, 62];  % 38 and 62 excluded from both  

for d = 2

    if d==1 
        subjincl=setdiff(list_total,subjexcl_d1);
        subjincl=subjincl(49:end);  
        disp(numel(subjincl));
    elseif d==2
        subjincl=setdiff(list_total,subjexcl_d2);
        subjincl=subjincl(59:60);
        disp(numel(subjincl));
    end
    

    for c_subj = subjincl

        subjlist(c_subj).name
    
        a_fcwml_save_residuals(subjlist(c_subj).name, d)

    end
end