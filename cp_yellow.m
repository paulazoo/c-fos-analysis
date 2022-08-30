function cp_yellow(mouse)
%% Params
yellow_dir = 'E:\histology\paula\cellpose_data_copied\220830paula_yellow2\';

th_base_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH\';
th_img_folder = [mouse '\'];
th_channel_num = '1';

cfos_base_dir = 'E:\histology\paula\cellpose_data_copied\220830paula_CFOS\';
cfos_img_folder = [mouse '\'];
cfos_channel_num = '2';

th_file_list = dir(fullfile([th_base_dir th_img_folder], ['C' th_channel_num '*.png']));
th_file_list = {th_file_list.name};
th_file_list = strrep(th_file_list, '.png', '');

cfos_file_list = dir(fullfile([cfos_base_dir cfos_img_folder], ['C' cfos_channel_num '*.png']));
cfos_file_list = {cfos_file_list.name};
cfos_file_list = strrep(cfos_file_list, '.png', '');

%% Make New Folders
mkdir(yellow_dir, mouse);

[M, N] = size(th_file_list);
for i = 1:1:N
    %% Check if img_num is one to be analyzed
    % example filename: C1_PZ1_1.tif
    filename_split = split(th_file_list{i}, '_');
    A=filename_split(3);
    img_num = str2num(A{1});
    
    %% Load c-Fos masks
    cfos_masks = imread([cfos_base_dir cfos_img_folder 'C' cfos_channel_num '_' mouse '_' num2str(img_num) '_cropped_cp_masks.png']);
    
    %% Load TH masks
    th_cp_masks = imread([th_base_dir th_img_folder th_file_list{i} '.png']);
    
    %% Calculate TH cells w c-Fos
    rois = regionprops(th_cp_masks, cfos_masks, "PixelValues");
    roi_pixels = regionprops(th_cp_masks, "PixelIdxList");
    [M, N] = size(rois);

    yellow_count = 0;
    yellow_png = zeros(size(cfos_masks));
    for roi_i = 1:1:M
        roi_values = rois(roi_i).PixelValues;
        roi_max = max(roi_values(:));
        if roi_max > 0
            yellow_count = yellow_count + 1;
            yellow_png(roi_pixels(roi_i).PixelIdxList) = yellow_count;
        end
    end
    yellow_png = uint16(yellow_png);

    %% Write Yellow Results
    imwrite(yellow_png, [yellow_dir mouse '\C4_' mouse '_' num2str(img_num) '.png'])
end
end
