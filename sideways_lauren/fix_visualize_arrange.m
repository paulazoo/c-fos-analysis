
mouse = 'PZ5';

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH14\';
img_folder = [mouse '\'];
ln_folder = [mouse '_ln\'];

file_list = dir([base_dir '\' img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

%%
for i = 1:1:length(file_list)
    %% Load image
    img = imread([base_dir img_folder file_list{i} '.tif']);
    
    adjusted_img = imadjust(img);
    figure('Name', [mouse '_' int2str(i)])
    imshow(adjusted_img)
end
