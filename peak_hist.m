%% Params
mouse = 'PZ21';
hist_color = 'g-';
masks_dir = 'E:\histology\paula\cellpose_data_copied\paula_yellow\';
masks_folder = [mouse '\'];

img_dir = 'E:\histology\paula\cellpose_data_copied\paula_cFos16\';
img_folder = [mouse '\'];

file_list = dir([img_dir img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

maskfile_list = dir([masks_dir masks_folder '*.png']);
maskfile_list = {maskfile_list.name};
maskfile_list = strrep(maskfile_list, '.png', '');

%%
peak_vals = [];
for i = 14:1:16
    %% Load image
    img = imread([img_dir img_folder file_list{i} '.tif']);

    %% Img num
            split_filename = split(file_list{i}, '_');
        img_num_str = split_filename(3, 1);
        img_num_str = img_num_str{1};
    %% Load masks
    masks = imread([masks_dir masks_folder 'C4_' mouse '_' img_num_str '.png']);

    %% CP Area Filter
    mask_rois = regionprops(masks, img, "PixelValues");

    [M, N] = size(mask_rois);
    temp_peak_vals = zeros(M, 1);
    for roi_i = 1:1:M
        roi_vals = mask_rois(roi_i).PixelValues;
        temp_peak_vals(roi_i, 1) = max(roi_vals(:));
    end
    
    %% Add to all peak_vals
    peak_vals = vertcat(peak_vals, temp_peak_vals);
end

%% Plot histogram curve
[values, edges] = histcounts(peak_vals, 100);
centers = (edges(1:end-1)+edges(2:end))/2;
hold on
plot(centers, values, hist_color)
