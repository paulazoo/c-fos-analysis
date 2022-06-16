% d = delete, a = add, p = save, q = quit w/o saving
subtract_tissuemask = 0;
% batch = 'paula_TH22';
mouse = 'SZ897';

if subtract_tissuemask == 1
    % load tissuemask mat file
    [tissuemaskfile,tissuemaskpath] = uigetfile('*_tissuemask_cropped.mat', 'Select tissuemask matlab file', ['E:\histology\paula\' mouse '\cropped']);
    load([tissuemaskpath tissuemaskfile])
end

% load roi mask png file
[maskfile,maskpath] = uigetfile('.png', 'Select mask png', ['E:\histology\stephen\' mouse]);
mask_png = imread([maskpath maskfile]);
if subtract_tissuemask == 1
    mask_png(tissue_mask == 0) = 0;
end

rois = regionprops(mask_png,'Centroid', 'PixelIdxList');
roi_centroids = cat(1,rois.Centroid);
mask_perim = bwperim(mask_png);

% load base image tif file
[imgfile,imgpath] = uigetfile('.tif', 'Select image tif', ['E:\histology\stephen\' mouse]);
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
        imwrite(mask_png, [maskpath maskfile])
        disp(['Mask saved to ' maskfile])
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

