% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\lloydb\surfdrive\ExperimentData\NYU_RS_LC\scripts\4_ROIs\f_script_make_binary_from_mask_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
