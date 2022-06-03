
subtract_tissuemask = 1;

if subtract_tissuemask == 1
    % load tissuemask mat file
    [tissuemaskfile,tissuemaskpath] = uigetfile('.mat', 'Select tissuemask matlab file', 'E:\histology\paula');
    load([tissuemaskpath tissuemaskfile])
end

% load roi mask png file
[maskfile,maskpath] = uigetfile('.png', 'Select mask png', 'E:\histology\paula\cellpose_data_copied\paula_TH22');
mask_png = imread([maskpath maskfile]);
if subtract_tissuemask == 1
    mask_png(tissue_mask == 0) = 0;
end

rois = regionprops(mask_png,'Centroid', 'PixelIdxList');
roi_centroids = cat(1,rois.Centroid);
mask_perim = bwperim(mask_png);

% load base image tif file
[imgfile,imgpath] = uigetfile('.tif', 'Select image tif', 'E:\histology\paula\cellpose_data_copied\paula_TH22');
img_tif = imread([imgpath imgfile]);
img_a = imadjust(img_tif);
[M, N] = size(img_a);

figure('Name', imgfile)
roi_overlay = imoverlay(img_a, mask_perim, [1 0.1 .1]);
imshow(roi_overlay)

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
    value = double(get(gcf,'CurrentCharacter'));
    % disp(value)
    if value == 100
        % 100 = d = delete
        h = imfreehand(gca);
        delete_region = createMask(h);
        mask_png(delete_region) = 0;
        mask_perim = bwperim(mask_png);
        roi_overlay = imoverlay(img_a, mask_perim, [1 0.1 .1]);
        disp('ROIs in selected region deleted.')
        imshow(roi_overlay)
    elseif value == 97
        % 97 = a = add
        h = imfreehand(gca);
        add_roi = createMask(h);
        max_roi_idx = max(mask_png(:));
        mask_png(add_roi) = (max_roi_idx + 1);
        mask_perim = bwperim(mask_png);
        roi_overlay = imoverlay(img_a, mask_perim, [1 0.1 .1]);  
        disp('ROI added.')
        imshow(roi_overlay)
    elseif value == 112
        % 112 = p = save
        imwrite(mask_png, [maskpath maskfile])
        disp(['Mask saved to ' maskfile])
    elseif value == 113
        % 113 = q = quit (without saving)
        disp('Quitting without saving...')
        close('all')
        user_done = 1;
    else
        disp('unrecognized key: ')
        disp(value)
    end
    
end

