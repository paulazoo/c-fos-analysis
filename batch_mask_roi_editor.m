% d = delete, a = add, p = save, q = quit w/o saving
% do first run through ignoring super bright groups
% then second run through locate super bright groups and use local
% normalized image as reference

subtract_tissuemask = 1;
batch = 'paula_TH22';
channel_num = 1;
mouse = 'PZ25';

for img_num = 1:1:16

    if subtract_tissuemask == 1
        % load tissuemask mat file
        % [tissuemaskfile,tissuemaskpath] = uigetfile('*_tissuemask_cropped.mat', 'Select tissuemask matlab file', ['E:\histology\paula\' mouse '\cropped']);
        load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'])
    end

    % load roi mask png file
    % [maskfile,maskpath] = uigetfile('.png', 'Select mask png', ['E:\histology\paula\cellpose_data_copied\' batch '\' mouse]);
    mask_png = imread(['E:\histology\paula\cellpose_data_copied\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
    if subtract_tissuemask == 1
        mask_png(tissue_mask == 0) = 0;
    end
    mask_png = bwareaopen(mask_png, 50);

    rois = regionprops(mask_png,'Centroid', 'PixelIdxList');
    roi_centroids = cat(1,rois.Centroid);
    mask_perim = bwperim(mask_png);

    % load base image tif file
    % [imgfile,imgpath] = uigetfile('.tif', 'Select image tif', ['E:\histology\paula\cellpose_data_copied\' batch '\' mouse]);
    img_tif = imread(['E:\histology\paula\cellpose_data_copied\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped.tif']);
    img_a = imadjust(img_tif);
    [M, N] = size(img_a);

    figure('Name', [mouse '_' int2str(img_num)])
    roi_overlay = imoverlay(img_a, mask_perim, [1 0.1 .1]);
    imshow(roi_overlay)
    set(gcf, 'Position', get(0, 'Screensize'));

    user_done = 0;
    while user_done == 0
        k = waitforbuttonpress;
        % 28 leftarrow
        % 29 rightarrow
        % 30 uparrow
        % 31 downarrow
        % 32 spacebar
        % 100 d
        % 97 a
        % 113 q
        % 101 e
        keyvalue = double(get(gcf,'CurrentCharacter'));
        % disp(value)
        if keyvalue == 100
            % 100 = d = delete
            h = imfreehand(gca);
            delete_region = createMask(h);
            mask_png(delete_region) = 0;
            mask_perim = bwperim(mask_png);
            roi_overlay = imoverlay(img_a, mask_perim, [1 0.1 .1]);
            disp('ROIs in selected region deleted.')
            keyvalue = 32;
            imshow(roi_overlay)
            set(gcf, 'Position', get(0, 'Screensize'));
        elseif keyvalue == 97
            % 97 = a = add
            h = imfreehand(gca);
            add_roi = createMask(h);
            max_roi_idx = max(mask_png(:));
            mask_png(add_roi) = (max_roi_idx + 1);
            mask_perim = bwperim(mask_png);
            roi_overlay = imoverlay(img_a, mask_perim, [1 0.1 .1]);  
            disp('ROI added.')
            keyvalue = 32;
            imshow(roi_overlay)
            set(gcf, 'Position', get(0, 'Screensize'));
        elseif keyvalue == 112
            % 112 = p = save
            mask_png = bwareaopen(mask_png, 50);
            imwrite(mask_png, ['E:\histology\paula\cellpose_data_copied\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_cp_masks.png'])
            disp(['Mask saved to C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_cp_masks.png'])
            keyvalue = 32;
        elseif keyvalue == 113
            % 113 = q = quit (without saving)
            disp('Quitting this image...')
            close('all')
            user_done = 1;
        elseif keyvalue == 32
            % 32 = spacebar does nothing but clear keyvalue's value
        else
            disp('unrecognized key: ')
            disp(keyvalue)
        end

    end

end

