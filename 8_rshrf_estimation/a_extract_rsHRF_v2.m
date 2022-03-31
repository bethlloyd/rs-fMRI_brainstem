function a_extract_rsHRF_v2(BF, numBF)

%% This script collects all the HRF vectors 


%% Path settings ----------------------------------------------------------
%Clus_data='/data/lloydb/data';
homeD='D:\NYU_RS_LC\';
homeF='F:\NYU_RS_LC\';
stats=fullfile(homeF,'stats');
subjpath=fullfile(homeD,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));

addpath('E:\NYU_RS_LC\scripts');
addpath('E:\NYU_RS_LC\scripts/0_general');

%% Define which day -------------------------------------------------------
% if ~exist('day')
%     day=char(inputdlg('Which day?'));
% end
%day='1';

%% Define subject numbers -------------------------------------------------
subj_list = 72;


%% Define ROIs
roi = {'DR', 'MR', 'VTA', 'ACC', 'LC', 'SN', 'OCC', 'BF_sept', 'BF_subl'};

%% define basis functions 
%basisfuncs = {'1_canonical', '2_gammafuncs'};
%bf = 1;
% save headers
%--------------------------------------------------------------------------
extract_HRF(1,1)=cellstr('subj');
extract_HRF(1,2)=cellstr('time');
for c_roi = 1:numel(roi)
    extract_HRF(1,2+(c_roi))=cellstr(roi{c_roi});
end

% save headers = event number
%--------------------------------------------------------------------------
event_num(1,1)=cellstr('subj');
for c_roi = 1:numel(roi)
    event_num(1,1+(c_roi))=cellstr(roi{c_roi});
end


% save headers = event times 
TTP(1,1)=cellstr('subj');
for c_roi = 1:numel(roi)
    TTP(1,1+(c_roi))=cellstr(roi{c_roi});
end



%% GATHER HRF VECTORS -----------------------------------------------------
% Loop over subjects
for c_subj = 1:subj_list
    subjlist(c_subj).name
    
    for c_roi = 1:numel(roi)


        
        %% load in HRF scruct file
        hrf_filename = ['Deconv_aff_u', subjlist(c_subj).name,'_0006_hrf.mat'];
        hrf_filenameBF = ['Deconv_saff_u', subjlist(c_subj).name,'_0006_hrf.mat'];
        if numBF == 1
            if c_roi == 8
                hrf_vec = load(fullfile(stats, 'rsHRF', subjlist(c_subj).name, 'concat', BF, 'BF_rois', hrf_filenameBF));
                % get the event numbers for each ROI 
                event_num_all=hrf_vec.event_number(1);
                % get the event times for each ROI 
                event_onsets=hrf_vec.event_bold{1};
                event_time(1,1)=cellstr('subj');
                event_time(1,2)=cellstr(roi{c_roi});
                
                
            elseif c_roi == 9
                hrf_vec = load(fullfile(stats, 'rsHRF', subjlist(c_subj).name, 'concat', BF, 'BF_rois', hrf_filenameBF));
                % get the event numbers for each ROI 
                event_num_all=hrf_vec.event_number(2);
                % get the event times for each ROI 
                event_onsets=hrf_vec.event_bold{2};
                event_time(1,1)=cellstr('subj');
                event_time(1,2)=cellstr(roi{c_roi});
                
            else
                %hrf_vec = load(fullfile(stats, 'rsHRF', subjlist(c_subj).name, ['ses-day-', num2str(sess)], BF, hrf_filename));
                hrf_vec = load(fullfile(stats, 'rsHRF', subjlist(c_subj).name, 'concat', BF, hrf_filename));
                % get the event numbers for each ROI 
                event_num_all=hrf_vec.event_number(c_roi);
                % get the event times for each ROI 
                event_time(1,1)=cellstr('subj');
                event_time(1,2)=cellstr(roi{c_roi});
                % get the event times for each ROI 
                event_onsets=hrf_vec.event_bold{c_roi};

            end
            
        elseif numBF == 2
            %hrf_vec = load(fullfile(stats, 'rsHRF', subjlist(c_subj).name, ['ses-day-', num2str(sess)], string(extractBetween(BF,1,7)), hrf_filename));
            hrf_vec = load(fullfile(stats, 'rsHRF', subjlist(c_subj).name, 'concat', string(extractBetween(BF,1,7)), hrf_filename));
        end
        
%          % get the x coording (timing)
%         if numBF == 1 % canonical = 32s
%             len_sec = 32;
% 
%         elseif numBF == 2 % gamma = 20s
%             len_sec = 20;
%         end
% 
%         div_factor = numel(hrf_vec.hrfa(:,1))/len_sec;
%         time_step = 1/div_factor;
%         x = 0:time_step:len_sec;
%         x(1)=[];
% 
%         if c_roi == 8
%             y_all=hrf_vec.hrfa(:,1);
%         elseif c_roi == 9
%             y_all=hrf_vec.hrfa(:,2);
%         else
%             y_all=hrf_vec.hrfa(:,c_roi);
%         end
%         % unit-normalize the response
%         y_hrf_norm = y_all - y_all(1);  % subtract value at t1
%         y_hrf_norm=y_hrf_norm/max(y_hrf_norm);   % divide timepoints by maximum value
%         y_hrf = y_hrf_norm';
% 
% 
%         % get the HRF for each roi 
%         if c_subj==1
%             extract_HRF(c_subj+1:numel(x)+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
%             extract_HRF(c_subj+1:numel(x)+1,2)=num2cell(x);
%             extract_HRF(c_subj+1:numel(x)+1,2+(c_roi))= num2cell(y_hrf);
%             
%             %for the TTP collection
%             subj_HRF = extract_HRF(c_subj+1:numel(x)+1,:);
%         else
%             %get the correct start and end rows
%             start_row = numel(x)*(c_subj-1)+2;
%             end_row = numel(x)*(c_subj-1)+2+numel(x)-1;
% 
%             %save the HRF vectors to struct
%             extract_HRF(start_row:end_row,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
%             extract_HRF(start_row:end_row,2)=num2cell(x);
%             extract_HRF(start_row:end_row,2+(c_roi))=num2cell(y_hrf);
%             
%             %for the TTP collection
%             subj_HRF = extract_HRF(start_row:end_row,:);
%         end
%         
         %save to struct
        event_num(c_subj+1, 1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
        event_num(c_subj+1, 1+(c_roi))=num2cell(event_num_all);

        %% save event onsets
        disp(['saving .. ', subjlist(c_subj).name]);
        
        event_time(2:1+numel(event_onsets),1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
        event_time(2:1+numel(event_onsets),2)=num2cell(event_onsets);

        filename=strcat([subjlist(c_subj).name, '_', roi{c_roi}, '_rsHRF_event_onsets_both_days.csv']);
        savefilename=fullfile(stats, 'rsHRF', 'groupstats', BF, 'event_onsets', filename);
        cell2csv(savefilename,event_time);
        clear event_time
        
       

    end %roi
    
%    %% get time to peak (based on max BOLD response)
%     [max_values,idx]=max(cell2mat(subj_HRF(2:end,3:11)));
%     out=[cell2mat(subj_HRF(idx',2)) max_values'];
%     
%     for c_roi = 1:numel(roi)
%         TTP(c_subj+1, 1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
%         TTP(c_subj+1,1+(c_roi))= num2cell(out(c_roi,1));
%     end %roi
  
    
    

end %subject


%% SAVE FILES -------------------------------------------------------------

%save extracted HRF
%filename=strcat(['rsHRF_noscale_day', num2str(sess), '.csv']);
% filename=strcat(['rsHRF_both_days.csv']);
% % filename=strcat(['rsHRF_day', num2str(sess), '.csv']);
% savefilename=fullfile(stats, 'rsHRF', 'groupstats', BF,filename);
% cell2csv(savefilename,extract_HRF);
% % 

% save event numbers
% filename=strcat(['rsHRF_event_num_both_days.csv']);
% savefilename=fullfile(stats, 'rsHRF', 'groupstats', BF,filename);
% cell2csv(savefilename,event_num);




%save time to peak values
% filename=strcat(['rsHRF_TTP_both_days.csv']);
% %filename=strcat(['rsHRF_TTP_day', num2str(sess), '.csv']);
% savefilename=fullfile(stats, 'rsHRF', 'groupstats', BF,filename);
% cell2csv(savefilename,TTP);
% 
% %% explore the deconvolved BOLD timecourse 
% for c_subj = 1:72
%     subjlist(c_subj).name
%     
%     %load in HRF scruct file
%     hrf_filename = ['Deconv_aff_u', subjlist(c_subj).name,'_0006.mat'];
%     hrf_vec = load(fullfile(subjpath, subjlist(c_subj).name, 'ses-day2', 'func',...
%         'rsHRF_ROI-wise_output', hrf_filename));
%     
%     %plot data + devonvolved BOLD
%     %figure('color','w');plot(zscore(hrf_vec.data(:,5))); hold on;
%     %plot(zscore(hrf_vec.data_deconv(:,5)));legend({'BOLD','Deconvolved BOLD'})
%     
% end

