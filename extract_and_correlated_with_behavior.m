% extract ROI estimates and correlate them with behavior

% select a one sample t-test to extract
one_sample_t_test_spm_mat_file = spm_select;

%% change the path of the SPM.mat file

%%% Current parent folder
current_parent_folder_of_one_sample_t_test_spm_mat_file  = fileparts(one_sample_t_test_spm_mat_file);

%%% Recorded parent folder
SPM = [];
load(one_sample_t_test_spm_mat_file);
recorded_parent_folder_of_one_sample_t_test_spm_mat_file = SPM.swd;

%%% if they are different, change the reorded parent folder
if ~strcmp(current_parent_folder_of_one_sample_t_test_spm_mat_file, recorded_parent_folder_of_one_sample_t_test_spm_mat_file)
    spm_changepath(one_sample_t_test_spm_mat_file, recorded_parent_folder_of_one_sample_t_test_spm_mat_file, current_parent_folder_of_one_sample_t_test_spm_mat_file);
end

%% Extract parameters- left caudate

% No code here. Open up the SPM results interface, load the
% one_sample_t_test_spm_mat_file, select the left caudate cluster on the 
% glass brain, right click and select 
% `Extract Data --> raw y --> this cluster`. This will create a 
% number_of_subjects x number_of_voxels matrix called `y` in the workspace.

spm('fMRI')

%% Take the median of the cluster

left_caudate = median(y, 2); % second dimension, for each row

%% Extract parameters- right caudate

% No code here. Open up the SPM results interface, load the
% one_sample_t_test_spm_mat_file, select the left caudate cluster on the 
% glass brain, right click and select 
% `Extract Data --> raw y --> this cluster`. This will create a 
% number_of_subjects x number_of_voxels matrix called `y` in the workspace.

%% Take the median of the cluster

right_caudate = median(y, 2); % second dimension, for each row

%% Finish up

% extract the subject IDs
subjects = cellfun(@char, regexp(SPM.xY.P, 'sub-s[0-9]{3}', 'match'), 'UniformOutput', false);

% create a table
roi_data = table(left_caudate, right_caudate, subjects);

% write out as a csv for reading into R
writetable(roi_data, 'roi-data.csv');
