clear all; clc;

home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));

%% Define which day -------------------------------------------------------


%% Define subject numbers -------------------------------------------------
% settings: excl day 1/2
subjexcl_d1=[15, 21, 37, 38, 47, 57, 62, 66, 69];   % subjs to excl from analysis day1 (note they are linked to order in list)
subjexcl_d2=[18, 21, 19, 24, 29, 31, 38, 52];             % subjs to excl from analysis day2

list_total=[1:72];


%% Define looped varaibles ---------------------------------------------------


%models={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};
%models={'DR_roi', 'MR_roi', 'LC_roi', 'VTA_roi', 'SN_roi'};
models={'P1', 'P2', 'P3', 'P4', 'P5'};
temporal_mod={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};

%smooth = {'smoothed', 'unsmoothed'};

%sess = {'ses-day-1', 'ses-day-2'};

%pup = {'pup_size', 'pup_deriv'};

for c_temp = 1:numel(temporal_mod)

    for mod = 1:numel(models)

        %for sm = 1:numel(smooth)

        for s = 1:numel(sess)
            % do not run excluded subjs
            if s==1 
                subjincl=setdiff(list_total,subjexcl_d1);
                disp(numel(subjincl));
            elseif s==2
                subjincl=setdiff(list_total,subjexcl_d2);
                disp(numel(subjincl));
            end

                %for p = 1:numel(pup)

            for c_subj=subjincl
%                 disp(subjlist(c_subj).name);
%                 disp(models{mod});
%                 %disp(smooth{sm});
%                 disp(sess{s});
%                 %disp(pup{p});
%                 disp(temporal_mod{c_temp});

                [con_stat] = a_extract_1stlev_con_no_conv(subjlist(c_subj).name, models{mod}, sess{s}, temporal_mod{c_temp});


            %disp(nvox_overlap)

              % SAVE DATA
                %--------------------------------------------------------------------------
                extract_con_file(1, 1)=cellstr('subj');
                extract_con_file(1, 2)=cellstr('spmT_0001.nii');

                extract_con_file(c_subj+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
                extract_con_file(c_subj+1,2)=num2cell(con_stat);


                stats_dir=fullfile(homeD, 'stats');
                statspath=fullfile(stats_dir, 'template_1st_level_pipelines', 'smoothed', temporal_mod{c_temp});

                %make outputfile 
                output_path = fullfile(statspath, 'groupstats', sess{s}, 'pup_size', 'extract_stat');
                 % make output dir if none
                if ~exist(output_path, 'dir')
                    mkdir(output_path);
                end

                filename=strcat(['con_stat_', models{mod}, '.csv']);
                savefilename=fullfile(output_path,filename);
                cell2csv(savefilename,extract_con_file);

            end
        end 
        %end 
    end 
end

