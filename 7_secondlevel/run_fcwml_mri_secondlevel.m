%% This script runs a_fcwml_mri_secondlevel 

% note: before running this - you need to have ran 'move_contrasts' for each
% model

clear all
clc




%% Define looped varaibles ---------------------------------------------------


%models={'1_m2_bin', '2_m1_bin', '3_0bin', '4_p1_bin', '5_p2_bin'};
models={'DR_roi', 'MR_roi', 'LC_roi', 'VTA_roi', 'SN_roi', 'ACC_roi', 'OCC_roi', 'BF_subl_roi', 'BF_sept_roi'};
%models={'P1', 'P2', 'P3', 'P4', 'P5'};
smooth = {'smoothed', 'unsmoothed'};

%sess = {'ses-day-1', 'ses-day-2'};

pup = {'pup_size', 'pup_deriv'};

NP = {'T_pos1', 'T_neg1'};

for mod = 8:9
        
    for sm = 1:2
        
        
        for p = 1:2

            
            disp(['now running ', smooth{sm}, ' model ', models{mod}, pup{p}]);
            a_fcwml_mri_secondlevel(models{mod}, smooth{sm}, pup{p});

            
        end
        
    end

end
