% move masks into another folder 

homeE='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
stats=fullfile(homeD,'stats');
subjpath=fullfile(homeE,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));

day = {'1', '2'};

for c_subj = 1:72
    for sess = 1:2
        
        SUBJNAME = subjlist(c_subj).name
        SUBJNAMEcbi=erase(SUBJNAME,'_');

        %input_mask = ['E:\NYU_RS_LC\data\', subjlist(c_subj).name, '\ses-day2\ROI\LC\rater_2\', 'T_template0_', subjlist(c_subj).name, '.nii'];

        %output_mask = ['E:\NYU_RS_LC\masks\indiv_LC_masks\rater1\', 'T_template0_', subjlist(c_subj).name, '.nii'];

        % move the aff images to their folde in cluster_data
        %saff_filepath = ['E:\NYU_RS_LC\data\', SUBJNAME, '\ses-day', day{sess}, '\func\sub-', SUBJNAMEcbi, '_ses-day', day{sess}, '_task-rest_acq-normal_run-01_bold'];
        %retroicor_filepath = ['E:\NYU_RS_LC\data\', SUBJNAME, '\ses-day', day{sess}, '\func\sub-', SUBJNAMEcbi, '_ses-day', day{sess}, '_task-rest_acq-normal_run-01_bold\log\hrf_est_regressors'];
        temporal_maskpath = ['E:\NYU_RS_LC\data\', SUBJNAME, '\ses-day', day{sess}, '\func\sub-', SUBJNAMEcbi, '_ses-day', day{sess}, '_task-rest_acq-normal_run-01_bold\log\temporal_mask'];
        
        %aff_ims = dir(fullfile(saff_filepath,'saff_u*'));
        %retroicor_ims = dir(fullfile(retroicor_filepath,'hrf*'));
        tempmask_ims = dir(fullfile(temporal_maskpath, 'temporal*'));
        output_path = ['D:\NYU_RS_LC\cluster_RETROICOR_data\', SUBJNAME, '\ses-day', day{sess}, '\func\sub-', SUBJNAMEcbi, '_ses-day', day{sess}, '_task-rest_acq-normal_run-01_bold\log\temporal_mask'];
        if ~exist(output_path, 'dir')
            mkdir(output_path)
        end
        
%         for i = 1:150
%             input_file = fullfile(retroicor_filepath, retroicor_ims(i).name);
%             output_file = fullfile(output_path, aff_ims(i).name);
%             
%             copyfile(input_file, output_file);
%             
%         end
        
        input_file = fullfile(temporal_maskpath, tempmask_ims.name);
        output_file = fullfile(output_path, tempmask_ims.name);
             
        copyfile(input_file, output_file);
        
        %copyfile(input_mask, output_mask);
    end
end