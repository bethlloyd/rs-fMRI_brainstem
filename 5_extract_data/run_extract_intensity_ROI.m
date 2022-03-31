clear all; clc;

home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));

savepath='D:\NYU_RS_LC\stats\LC_mask\intensity_analysis';


%% Define subject numbers -------------------------------------------------
list_total=[1:72];


%% Define looped varaibles ---------------------------------------------------

for c_subj=1:72
    disp(['now running subj ', subjlist(c_subj).name]);
    [intensity] = a_extract_intensity_ROI(subjlist(c_subj).name);


%disp(nvox_overlap)

  % SAVE DATA
    %--------------------------------------------------------------------------
    con_stat(1, 1)=cellstr('subj');
    con_stat(1, 2)=cellstr('LC_intensity');
    con_stat(1, 3)=cellstr('PONS_intensity');
    con_stat(c_subj+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));

    con_stat(c_subj+1,2) = intensity(1);
    con_stat(c_subj+1,3) = intensity(2);
    
    %make outputfile 
    output_path = savepath;
     % make output dir if none
    if ~exist(output_path, 'dir')
        mkdir(output_path);
    end

    filename=strcat('LC_PONS_intensity.csv');
    savefilename=fullfile(output_path,filename);
    cell2csv(savefilename,con_stat);

end


