clear all; clc;

home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';

subjpath='D:\NYU_RS_LC\stats\template_1st_level_pipelines\smoothed\BF_subl_roi';
subjlist=dir(fullfile(subjpath,'MRI*'));
addpath('E:\NYU_RS_LC\scripts');


%% Define subject numbers -------------------------------------------------
% settings: excl day 1/2
subjexcl_d1=[15, 21, 37, 38, 47, 57, 62, 66, 69];   % subjs to excl from analysis day1 (note they are linked to order in list)
subjexcl_d2=[18, 21, 19, 24, 29, 31, 38, 52];             % subjs to excl from analysis day2

list_total=[1:70];


%% Define looped varaibles ---------------------------------------------------


%models={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};
ROI={'DR_roi', 'MR_roi', 'LC_roi', 'VTA_roi', 'SN_roi', 'ACC_roi', 'OCC_roi', 'BF_sept_roi', 'BF_subl_roi'};
models={'P1', 'P2', 'P3', 'P4', 'P5', 'P6'};
%temporal_mod={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};

smooth = {'smoothed', 'unsmoothed'};

%sess = {'ses-day-1', 'ses-day-2'};

pup = {'pup_size', 'pup_deriv'};



%for mod =1:numel(models)

for sm = 1:2
    for roi = 8:9%1:numel(ROI)
        disp(['running..', ROI{roi}]);
        disp(['running..', smooth{sm}]);
        for p = 1:2

            for c_subj=list_total
                disp(subjlist(c_subj).name)
                [con_stat] = a_extract_1stlev_con_roi(subjlist(c_subj).name, ROI{roi}, smooth{sm}, pup{p});


            %disp(nvox_overlap)

              % SAVE DATA
                %--------------------------------------------------------------------------
                extract_con_file(1, 1)=cellstr('subj');
                extract_con_file(1, 2)=cellstr('spmT_0001.nii');

                extract_con_file(c_subj+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
                extract_con_file(c_subj+1,2)=num2cell(con_stat);


                stats_dir=fullfile(homeD, 'stats');
                statspath=fullfile(stats_dir, 'template_1st_level_pipelines', smooth{sm},  ROI{roi});

                %make outputfile 
                output_path = fullfile(statspath, 'groupstats', pup{p}, 'extract_stat');
                old_File = fullfile(statspath, 'groupstats', pup{p}, 'extract_stat');
                 % make output dir if none
                if ~exist(output_path, 'dir')
                    mkdir(output_path);
                end

    %                 if exist(fullfile(old_File, strcat(['con_stat_', models{mod}, '.csv'])), 'file')
    %                     delete(fullfile(old_File, strcat(['con_stat_', models{mod}, '.csv'])));
    %                 end
    %                 

                filename=strcat(['con_stat', '_', ROI{roi}, '_', pup{p}, '.csv']);
                savefilename=fullfile(output_path,filename);
                cell2csv(savefilename,extract_con_file);

            end
        end 
    end
    
end

