mouse = 'PZ25';

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH\';
img_folder = [mouse '\'];
tissuemask_folder = [mouse '_tissuemask\'];

file_list = dir([base_dir img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

%% Make Tissue Mask Folder
mkdir([base_dir tissuemask_folder])

for i = 1:1:length(file_list)
    %% Load image
    img = imread([base_dir img_folder file_list{i} '.tif']);
    adjusted_img = imadjust(img);

    %% Show image
    figure('Name', ['Draw tissue for ' mouse '_' int2str(img_num)])
    imshow(adjusted_img);
    
    %% Draw tissuemask
    hFH = imfreehand();
    tissue_mask = hFH.createMask();
    hole_done = 0;
    while hole_done == 0
        prompt = {'Edit more mask holes? 1 for yes:'};
        answer = inputdlg(prompt,'Analysis Properties',[1 50]);
        if answer{1} == '1'
            hFH = imfreehand();
            hole_mask = hFH.createMask();
            tissue_mask(hole_mask == 1) = 0;
        else
            hole_done = 1;
        end
    end
    % imshow(tissue_mask)

    %% Save result
    save([base_dir tissuemask_folder mouse '_' int2str(img_num) '_tissuemask.mat'], 'tissue_mask')

end