function output = rough_th_count(mouse)
base_dir = 'E:\histology\paula\cellpose_data_copied\stephen_TH14\';
img_folder = [mouse '_cropped\'];
ln_folder = [mouse '_ln\'];

file_list = dir([base_dir img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

output = zeros(length(file_list), 1);
    for i = 1:1:length(file_list)
        % Load cp masks
        cp_masks = imread([base_dir img_folder file_list{i} '_cp_masks.png']);
        cp_rois = regionprops(cp_masks, "Area");
        [M, N] = size(cp_rois);

        roi_count = 0;
        for roi_i = 1:1:M
            if cp_rois(roi_i).Area > 5
                roi_count = roi_count + 1;
            end
        end

        output(i, 1) = roi_count;
    end
end