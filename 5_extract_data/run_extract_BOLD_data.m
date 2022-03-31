clear all; clc;

home='E:\NYU_RS_LC\';
homeD='D:\NYU_RS_LC\';

subjpath=fullfile(home,'data');
subjlist=dir(fullfile(subjpath,'MRI*'));


%% Define subject numbers -------------------------------------------------
list_total=[1:72];
list_incl=[1:37, 39:61, 63:72];

smooth= {'smoothed', 'unsmoothed'};
pup={'pup_size', 'pup_deriv'};


for c_smooth = 1:2
    
    for c_pup = 1:2
        
        for c_subj=list_incl
    
            disp(['now running subj ', subjlist(c_subj).name]);
    
            [con_stat] = a_extract_BOLD_data(subjlist(c_subj).name,...
                smooth{c_smooth}, pup{c_pup});

            % SAVE DATA
            %--------------------------------------------------------------------------
            stat_file(1, 1)=cellstr('subj');
            stat_file(1, 2)=cellstr('con_stat');
            stat_file(c_subj+1,1)=cellstr(strcat(num2str(subjlist(c_subj).name)));

            stat_file(c_subj+1,2) = con_stat;
            
            
            % Make save folder
            savepath=fullfile('D:\NYU_RS_LC\stats\native_space_LC\',...
                smooth{c_smooth}, pup{c_pup});
            if ~exist(savepath, 'dir')
                mkdir(savepath);
            end
            
            filename=strcat('LC_native_space_stat.csv');
            savefilename=fullfile(savepath,filename);
            cell2csv(savefilename,stat_file);
        end
    end
end

