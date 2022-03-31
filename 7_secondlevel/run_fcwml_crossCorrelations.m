clear all; clc;

% Path settings
home='F:\NYU_RS_LC\';
homeE='E:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts');

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));
list_total=[1:72];
%subjexcl_d1=[4, 15, 21, 37, 38, 47, 57, 62, 66, 69];
%subjexcl_d2=[18, 19, 24, 29, 31, 38,  52, 62];  % 38 and 62 excluded from both  


% if d==1 
%     subjincl=setdiff(list_total,subjexcl_d1);
%     disp(numel(subjincl));
% elseif d==2
%     subjincl=setdiff(list_total,subjexcl_d2);
%     disp(numel(subjincl));
% end

ROIs = {'DR', 'MR', 'VTA', 'ACC', 'LC', 'SN', 'OCC', 'BF_sept', 'BF_subl'};
day = {'ses-day1', 'ses-day2'};
pup = {'pup_size', 'pup_deriv'};



for d = 1:2

    for roi=8:9 %1:numel(ROIs)

        for p = 1:2

            for c_subj = list_total
                
                disp(['running...', subjlist(c_subj).name, pup{p}, ROIs{roi}, day{d}]);
                % SAVE DATA
                %--------------------------------------------------------------------------
                extract_crosscorr(1, 1)=cellstr('subj');
                extract_crosscorr(1, 2)=cellstr('lag');
                extract_crosscorr(1, 3)=cellstr('CC');

                lag = 9;
                start_row = lag*(c_subj-1)+2;
                end_row =lag*(c_subj-1)+2+lag-1;
                lags = [-4;-3; -2; -1; 0; 1; 2; 3; 4];
                [corr]=f_fcwml_crossCorrelations(subjlist(c_subj).name, p, ROIs{roi}, d);

                if c_subj == 1                
                    extract_crosscorr(c_subj+1:numel(lags)+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
                    extract_crosscorr(c_subj+1:numel(lags)+1,2)=num2cell(lags);
                    extract_crosscorr(c_subj+1:numel(lags)+1,3)=num2cell(corr);

                else

                    extract_crosscorr(start_row:end_row,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
                    extract_crosscorr(start_row:end_row,2)=num2cell(lags);
                    extract_crosscorr(start_row:end_row,3)=num2cell(corr);
                end

            end 

            stats_dir=fullfile(homeE, 'stats');
            statspath=fullfile(stats_dir, 'BS_correlations', 'smoothed', 'group_stats_Xcorr');
            %make outputfile 
            output_path = fullfile(statspath, pup{p});
             % make output dir if none
            if ~exist(output_path, 'dir')
                mkdir(output_path);
            end

            filename=strcat(['XCorr_stat_', day{d}, '_', ROIs{roi},  '.csv']);
            savefilename=fullfile(output_path,filename);
            cell2csv(savefilename,extract_crosscorr);




        end 
    end
end
                
                
                
                
                
                