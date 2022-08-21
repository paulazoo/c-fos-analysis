
mouse = 'PZ';
base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';
img_folder = [mouse '_grid\'];
file_ext = 'mat';

file_list = dir([base_dir img_folder '*.' file_ext]);
file_list = {file_list.name};

for i =1:1:length(file_list)
   old_name = file_list{i};
   movefile([base_dir img_folder old_name] , [base_dir img_folder 'C0_' old_name]);
end