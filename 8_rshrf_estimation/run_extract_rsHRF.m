%% This script runs the rs HRF ROI batch
% 



%% Path settings ----------------------------------------------------------
home='D:\NYU_RS_LC\';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));

basisfuncs = {'1_canonical', '2_gammafuncs'};


for basfunc = 1%:numel(basisfuncs) 
    %for day = 1:2
        %Loop over subjects


    a_extract_rsHRF_v2(basisfuncs{basfunc}, basfunc);



        

    %end
end