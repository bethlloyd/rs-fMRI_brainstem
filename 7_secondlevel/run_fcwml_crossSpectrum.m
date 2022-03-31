clear all; clc;

% Path settings
homeE='E:\NYU_RS_LC\';
home='F:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts');

subjpath=fullfile(homeD,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));
list_total=[1:72];
subjexcl_d1=[4, 15, 21, 37, 38, 47, 57, 62, 66, 69];
subjexcl_d2=[18, 19, 24, 29, 31, 38,  52, 62];  % 38 and 62 excluded from both  



subjincl_D1=setdiff(list_total,subjexcl_d1);
subjincl_D2=setdiff(list_total,subjexcl_d2);


subjincl_total = numel(subjincl_D1)+numel(subjincl_D2);
disp(subjincl_total);

ROIs = {'DR', 'MR', 'VTA', 'ACC', 'LC', 'SN', 'OCC', 'BF'};
%ROIs = {'ACC', 'OCC'};
day = {'ses-day1', 'ses-day2'};
pup = {'pup_size', 'pup_deriv'};

size_len = 31;
% 
% DR_Cxy = zeros(size_len,1);
% MR_Cxy = zeros(size_len,1);
% VTA_Cxy = zeros(size_len,1);
% ACC_Cxy = zeros(size_len,1);
% LC_Cxy = zeros(size_len,1);
% SN_Cxy = zeros(size_len,1);
% OCC_Cxy = zeros(size_len,1);
% BF_Cxy = zeros(size_len,1);


for d = 1:2

    for roi=1:numel(ROIs)
        disp(ROIs{roi});
        for p = 1

            for c_subj = list_total
                
                disp(['running...', subjlist(c_subj).name, pup{p}, ROIs{roi}, day{d}]);
                % SAVE DATA
                %--------------------------------------------------------------------------
                extract_spectcorr(1, 1)=cellstr('subj');
                extract_spectcorr(1, 2)=cellstr('F_mscohere');
                extract_spectcorr(1, 3)=cellstr('Cxy');

                
                start_row = size_len*(c_subj-1)+2;
                end_row =size_len*(c_subj-1)+2+size_len-1;
                [Cxy,F_mscohere]=f_fcwml_crossSpectrum(subjlist(c_subj).name, p, ROIs{roi}, d);
                [Cxy_dontuse,F_use]=f_fcwml_crossSpectrum(subjlist(1).name, p, ROIs{roi}, d);
                
                % normalise (demean) the timcourse 
                Cxy_demeaned=Cxy - mean(Cxy);
%                 
%                 if roi==1
%                     disp('yes DR');
%                     DR_Cxy = DR_Cxy + Cxy;
%                 elseif roi==2
%                     disp('yes MR');
%                     MR_Cxy = MR_Cxy + Cxy;
%                 elseif roi==3
%                     disp('yes VTA');
%                     VTA_Cxy = VTA_Cxy + Cxy;
%                 elseif roi==4
%                     disp('yes ACC');
%                     ACC_Cxy = ACC_Cxy + Cxy;
%                 elseif roi==5
%                     disp('yes LC');
%                     LC_Cxy = LC_Cxy + Cxy;
%                 elseif roi==6
%                     disp('yes SN');
%                     SN_Cxy = SN_Cxy + Cxy;
%                 elseif roi==7
%                     disp('yes OCC');
%                     OCC_Cxy = OCC_Cxy + Cxy;
%                 elseif roi==8
%                     disp('yes BF');
%                     BF_Cxy = BF_Cxy + Cxy;
                              
                if c_subj == 1                
                    extract_spectcorr(c_subj+1:numel(Cxy)+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
                    extract_spectcorr(c_subj+1:numel(Cxy)+1,2)=num2cell(F_use);
                    extract_spectcorr(c_subj+1:numel(Cxy)+1,3)=num2cell(Cxy_demeaned);

                else

                    extract_spectcorr(start_row:end_row,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
                    extract_spectcorr(start_row:end_row,2)=num2cell(F_use);
                    extract_spectcorr(start_row:end_row,3)=num2cell(Cxy_demeaned);
                end
            end
 

            stats_dir=fullfile(homeE, 'stats');
            statspath=fullfile(stats_dir, 'BS_correlations', 'smoothed', 'group_stats_Xspect');
            %make outputfile 
            output_path = fullfile(statspath, pup{p});
             % make output dir if none
            if ~exist(output_path, 'dir')
                mkdir(output_path);
            end

            filename=strcat(['XSpect_stat_', day{d}, '_', ROIs{roi},  '.csv']);
            savefilename=fullfile(output_path,filename);
            cell2csv(savefilename,extract_spectcorr);

        end
    end 
end

% DR_Cxy_total=DR_Cxy/subjincl_total;
% MR_Cxy_total=MR_Cxy/subjincl_total;
% VTA_Cxy_total=VTA_Cxy/subjincl_total;
% ACC_Cxy_total=ACC_Cxy/subjincl_total;
% LC_Cxy_total=LC_Cxy/subjincl_total;
% SN_Cxy_total=SN_Cxy/subjincl_total;
% OCC_Cxy_total=OCC_Cxy/subjincl_total;
% BF_Cxy_total=BF_Cxy/subjincl_total;
                
%ACC_Pxy_total(ACC_Cxy_total < 0.1) = 0;
%OCC_Pxy_total(OCC_Cxy_total < 0.1) = 0;
% 
% tiledlayout(2,4);
% % Magnitude-Squared Coherence
% nexttile
% plot(F_Cxy,LC_Cxy_total)
% title('LC - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')
% 
% nexttile
% plot(F_Cxy,VTA_Cxy_total)
% title('VTA - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')
% 
% nexttile
% plot(F_Cxy,SN_Cxy_total)
% title('SN - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% 
% nexttile
% plot(F_Cxy,DR_Cxy_total)
% title('DR - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')
% 
% nexttile
% plot(F_Cxy,MR_Cxy_total)
% title('MR - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')
% 
% nexttile
% plot(F_Cxy,BF_Cxy_total)
% title('BF - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')
% 
% nexttile
% plot(F_Cxy,ACC_Cxy_total)
% title('ACC - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')
% 
% % Magnitude-Squared Coherence
% nexttile
% plot(F_Cxy,OCC_Cxy_total)
% title('OCC - Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% ylabel('arbitrary units')

                    
                
                