function show_mask(mouse, img_num)
    channel_num = 1;
    
    base_dir = 'E:\histology\paula\';
    
    % read in image
    img = imread([base_dir mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '.tif']);
    adjusted_img = imadjust(img);
    
    all_files = dir(fullfile([base_dir mouse '\'], '*.mat'));

    all_file_names = {all_files(:).name};
    total_mask = zeros(size(adjusted_img));
    for i=1:1:length(all_file_names)
        if endsWith(all_file_names{i}, 'mask.mat')
            disp(all_file_names{i})
            split_file_name = split(all_file_names{i}, '_');
            if split_file_name{2} == int2str(img_num)
                load([base_dir mouse '\' mouse '_' int2str(img_num) '_' split_file_name{3} '_mask.mat'], 'mask')
                mask_outline = bwperim(mask);
                total_mask = total_mask + mask_outline;
            end
        end
    end
    total_mask(total_mask ~= 0) = 1;
    
    overlay = imoverlay(adjusted_img, total_mask, [1 0.1 .1]);
    
    figure('Name', [mouse '_' int2str(img_num) 'Masks'])
    imshow(overlay)
end