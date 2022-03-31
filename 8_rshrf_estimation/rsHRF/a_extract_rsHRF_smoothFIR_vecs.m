

%% This script collects all the HRF vectors 


%% Path settings ----------------------------------------------------------
Clus_data='/data/lloydb/data';
%homeE='E:\NYU_RS_LC\';
stats=fullfile(Clus_data,'stats');
subjpath=fullfile(Clus_data,'rsHRF_data');
subjlist=dir(fullfile(subjpath,'MRI*'));

addpath('/data/lloydb/data/scripts');
addpath('/data/lloydb/data/scripts/1_general');

%% Define which day -------------------------------------------------------
% if ~exist('day')
%     day=char(inputdlg('Which day?'));
% end
day='1';

%% Define subject numbers -------------------------------------------------
subj_list = 3;


%% Define ROIs
roi = {'DR_roi', 'MR_roi', 'VTA_roi', 'DMN_roi', 'LC_roi', 'SN_roi', 'OCC_roi'};

%% define basis functions 
basisfuncs = {'1_canonical', '2_gammafuncs'};
bf = 1;
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
event_time(1,1)=cellstr('subj');
for c_roi = 1:numel(roi)
    event_time(1,1+(c_roi))=cellstr(roi{c_roi});
end



%% GATHER HRF VECTORS -----------------------------------------------------
% Loop over subjects
for c_subj = 1:subj_list
    subjlist(c_subj).name
    
    for c_roi = 1:numel(roi)
        
        

        %load in HRF scruct file
        hrf_filename = ['Deconv_saff_u', subjlist(c_subj).name,'_0006_hrf.mat'];
        hrf_vec = load(fullfile(subjpath, subjlist(c_subj).name, ['ses-day', [day]], basisfuncs{bf}, hrf_filename));

         % get the x coording (timing)
        if bf == 1 % canonical = 32s
            len_sec = 32;

        elseif bf == 2 % gamma = 20s
            len_sec = 20;
        end

        div_factor = numel(hrf_vec.hrfa(:,1))/len_sec;
        time_step = 1/div_factor;
        x = 0:time_step:len_sec;
        x(1)=[];


%             % unit-normalize the response
%             y_hrf_norm = y_all - y_all(1);  % subtract value at t1
%             y_hrf_norm=y_hrf_norm/max(y_hrf_norm);   % divide timepoints by maximum value
%             y_hrf = y_hrf_norm';


        % get the HRF for each roi 
        if c_subj==1
            extract_HRF(c_subj+1:numel(x)+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
            extract_HRF(c_subj+1:numel(x)+1,2)=num2cell(x);
            extract_HRF(c_subj+1:numel(x)+1,2+(c_roi))= num2cell(hrf_vec.hrfa(:,c_roi));
        else
            %get the correct start and end rows
            start_row = numel(x)*(c_subj-1)+2;
            end_row = numel(x)*(c_subj-1)+2+numel(x)-1;

            %save the HRF vectors to struct
            extract_HRF(start_row:end_row,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
            extract_HRF(start_row:end_row,2)=num2cell(x);
            extract_HRF(start_row:end_row,2+(c_roi))=num2cell(hrf_vec.hrfa(:,c_roi));
        end




        %% get the event numbers for each ROI 
        event_num_all=hrf_vec.event_number(c_roi);
        % save to struct
        event_num(c_subj+1, 1)=cellstr(strcat(num2str(subjlist(c_subj).name)));
        event_num(c_subj+1, 1+(c_roi))=num2cell(event_num_all);


        
    end %roi
    
end %subject


%% SAVE FILES -------------------------------------------------------------

%save extracted HRF
filename=strcat(['rsHRF_day', day, '.csv']);
savefilename=fullfile(stats, 'rsHRF',basisfuncs{bf},filename);
cell2csv(savefilename,extract_HRF);


% save event numbers
filename=strcat(['rsHRF_event_num_day', day, '.csv']);
savefilename=fullfile(stats, 'rsHRF',basisfuncs{bf},filename);
cell2csv(savefilename,event_num);
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

