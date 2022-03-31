clear all; clc;

% Path settings
home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';
addpath('E:\NYU_RS_LC\scripts');
addpath('E:\NYU_RS_LC\scripts\6_firstlevel');
savepath='D:\NYU_RS_LC\stats\BS_correlations\group_stats\denoised_unsmoothed';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));
list_total=[1:72];
subjexcl_d1=[4, 15, 21, 37, 38, 47, 57, 62, 66, 69];
subjexcl_d2=[18, 19, 24, 29, 31, 38,  52, 62];  % 38 and 62 excluded from both  

for d = 1:2

    if d==1 
        subjincl=setdiff(list_total,subjexcl_d1);
        disp(numel(subjincl));
    elseif d==2
        subjincl=setdiff(list_total,subjexcl_d2);
        disp(numel(subjincl));
    end
    
    corr_martix = zeros(6);
    p_matrix = zeros(6);
    
    % make headers for dataframe
    extracted_corr(1,1) = cellstr('subj');
    extracted_corr(1,2) = cellstr('LC_VTA');
    extracted_corr(1,3) = cellstr('LC_SN');
    extracted_corr(1,4) = cellstr('LC_DR');
    extracted_corr(1,5) = cellstr('LC_MR');
    extracted_corr(1,6) = cellstr('LC_PONS');
    extracted_corr(1,7) = cellstr('VTA_SN');
    extracted_corr(1,8) = cellstr('VTA_DR');
    extracted_corr(1,9) = cellstr('VTA_MR');
    extracted_corr(1,10) = cellstr('VTA_PONS');
    extracted_corr(1,11) = cellstr('SN_DR');
    extracted_corr(1,12) = cellstr('SN_MR');
    extracted_corr(1,13) = cellstr('SN_PONS');
    extracted_corr(1,14) = cellstr('DR_MR');
    extracted_corr(1,15) = cellstr('DR_PONS');
    extracted_corr(1,16) = cellstr('MR_PONS');
    
    for c_subj = list_total
        disp(['running subject...', subjlist(c_subj).name]);
        if ismember(c_subj,subjincl)
            disp(['running subject...', subjlist(c_subj).name]);
            [r p]=a_extract_BS_signal_and_correlate(subjlist(c_subj).name,d, '1');

            % log the corr values in a dataframe
        else
            r = NaN(6);
        end
        
        extracted_corr(c_subj+1,1)= cellstr(subjlist(c_subj).name);
        extracted_corr(c_subj+1,2)=num2cell(r(2,1)); % LC_VTA
        extracted_corr(c_subj+1,3)=num2cell(r(3,1)); % LC_SN
        extracted_corr(c_subj+1,4)=num2cell(r(4,1)); % LC_DR
        extracted_corr(c_subj+1,5)=num2cell(r(5,1)); % LC_MR
        extracted_corr(c_subj+1,6)=num2cell(r(6,1)); % LC_PONS
        extracted_corr(c_subj+1,7)=num2cell(r(3,2)); % VTA_SN
        extracted_corr(c_subj+1,8)=num2cell(r(4,2)); % VTA_DR
        extracted_corr(c_subj+1,9)=num2cell(r(5,2)); % VTA_MR
        extracted_corr(c_subj+1,10)=num2cell(r(6,2)); % VTA_PONS
        extracted_corr(c_subj+1,11)=num2cell(r(4,3)); % SN_DR
        extracted_corr(c_subj+1,12)=num2cell(r(5,3)); % SN_MR
        extracted_corr(c_subj+1,13)=num2cell(r(6,3)); % SN_PONS
        extracted_corr(c_subj+1,14)=num2cell(r(5,4)); % DR_MR
        extracted_corr(c_subj+1,15)=num2cell(r(6,4)); % DR_PONS
        extracted_corr(c_subj+1,16)=num2cell(r(6,5)); % MR_PONS
        
        
        
        %corr_martix = (corr_martix + r);
        %p_matrix = (p_matrix + p);
    end

    % save the dataframe 
    %make outputfile 
    output_path = savepath;
     % make output dir if none
    if ~exist(output_path, 'dir')
        mkdir(output_path);
    end

    filename=strcat(['day' num2str(d) '_BS_PONS_correlations.csv']);
    savefilename=fullfile(output_path,filename);
    cell2csv(savefilename,extracted_corr);

%     corr_martix=corr_martix/numel(subjincl);
%     p_matrix=p_matrix/numel(subjincl);
%     if d==1 
%         corr_martix_D1 = corr_martix;
%         p_matrix_D1 = p_matrix;
%     elseif d == 2
%         corr_martix_D2 = corr_martix;
%         p_matrix_D2 = p_matrix;
%     end
end

% corr_matrix_combi = (corr_martix_D1 + corr_martix_D2)/2;
% p_matrix_combi = (p_matrix_D1 + p_matrix_D2)/2;
% 



% 
% % prep for image 
% clrLim = [0,1];
% % Plot the data using imagesc() for later comparison
% figure()
% ii = ones(size(corr_matrix_combi));
% idx = tril(ii);
% corr_matrix_combi(~idx) = nan;
% h=heatmap(corr_matrix_combi, 'MissingDataColor', 'w', 'GridVisible', 'off', 'MissingDataLabel', " ");
% h.XDisplayLabels = {'LC','VTA', 'SN', 'DR', 'MR'};
% h.YDisplayLabels = {'LC','VTA', 'SN', 'DR', 'MR'};
% colormap(gca,'summer');
% 
% 
% 
% % prep for image 
% clrLim = [0,1];
% % Plot the data using imagesc() for later comparison
% figure()
% ii = ones(size(p_matrix_combi));
% idx = tril(ii);
% corr_matrix_combi(~idx) = nan;
% h=heatmap(corr_matrix_combi, 'MissingDataColor', 'w', 'GridVisible', 'off', 'MissingDataLabel', " ");
% h.XDisplayLabels = {'LC','VTA', 'SN', 'DR', 'MR'};
% h.YDisplayLabels = {'LC','VTA', 'SN', 'DR', 'MR'};
% colormap(gca,'summer');


