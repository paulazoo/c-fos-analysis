
mouse = 'PZ5';

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';
img_folder = [mouse '\'];
ln_folder = [mouse '_ln\'];

file_list = dir([base_dir '\' img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

%% Params
cp_diameter = 23;
subtract_tissuemask = 0;
tissuemask_folder = [mouse '_tissuemask\'];

show_result = 0;

%% CP Notes

% remember to try multiple diameters to really get down to the optimal one
% edit cp filter prctile values before batch running


for i = 1:1:length(file_list)
    %% Load image
    th_img = imread([base_dir img_folder file_list{i} '.tif']);
    
    %% Load cp masks
    cp_masks = imread([base_dir img_folder file_list{i} '_cp_masks.png']);
    cp_masks1 = cp_masks;
    
    %% Get and subtract tissuemask file if needed
    % Could be better with just naming tissue masks based on matching entire filename because
    % not all have the img_num in 3rd position...
    if subtract_tissuemask == 1
        % Get img_num
        split_filename = split(file_list{i}, '_');
        img_num_str = split_filename(3, 1);
        % load tissuemask mat file
        load([base_dir '\' tissuemask_folder img_num_str '_tissuemask_cropped.mat'], 'tissue_mask')
    end
    
    %% Check cp masks (debugging)
    th_img_a = imadjust(th_img);
    cp_over = labeloverlay(th_img_a, cp_masks);
    
    %% CP Area Filter
    cp_rois = regionprops(cp_masks1, "Area", "PixelIdxList");
    
    [M, N] = size(cp_rois);
    for roi_i = 1:1:M
        if cp_rois(roi_i).Area < 50
            cp_masks1(cp_rois(roi_i).PixelIdxList) = 0;
        end
    end
    
    %% Check cp masks (debugging)
    th_img_a = imadjust(th_img);
    cp_over1 = labeloverlay(th_img_a, cp_masks1);
    
    %% Local Normalize for finding cell (and not axon surrounded) regions Params
    gausssizes = [cp_diameter, cp_diameter*3];
    medsizes = [2, 2];

    %% Local Normalize

    % 2D filter
    th_img2 = medfilt2(th_img, medsizes, 'symmetric');

    % gaussian normalize
    f_prime = single(th_img2)-single(imgaussfilt(single(th_img2),gausssizes(1)));
    ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
    ln_img(isnan(ln_img)) = 0;

    %% Local Normalize Threshold
    % use 75th percentile from ln image
    ln_thresh  = prctile(ln_img(:), 75);
    % disp(ln_thresh)

    ln_img3 = ln_img;
    ln_img3(ln_img3 < ln_thresh) = 0;

    %% CP Average LN Pixel Value Filter
    cp_masks2 = cp_masks1;
    
    cp_roi_lnvals = regionprops(cp_masks2, ln_img, "PixelValues");
    cp_rois = regionprops(cp_masks2, "PixelIdxList");
    
    [M, N] = size(cp_roi_lnvals);
    for roi_i = 1:1:M
        roi_pixels = cp_roi_lnvals(roi_i).PixelValues;
        if mean(roi_pixels(:)) < ln_thresh
            cp_masks2(cp_rois(roi_i).PixelIdxList) = 0;
        end
    end
    
    
    %% Check cp masks (debugging)
    cp_over2 = labeloverlay(th_img_a, cp_masks2);
    
    %% Get intensity threshold
    % use 80th percentile from original image
    int_thresh  = prctile(th_img(:), 80);
        
    %% Especially prominent peaks are okay
    % use 99th percentile for ln prom thresh
    prom_thresh = prctile(ln_img(:), 99);
            
    %% CP Low Int, Low Prom Filter
    cp_masks3 = cp_masks2;
    
    cp_roi_intvals = regionprops(cp_masks3, th_img, "PixelValues");
    cp_roi_promvals = regionprops(cp_masks3, ln_img, "PixelValues");
    cp_rois = regionprops(cp_masks3, "PixelIdxList");
    
    [M, N] = size(cp_rois);
    for roi_i = 1:1:M
        int_pixels = cp_roi_intvals(roi_i).PixelValues;
        if mean(int_pixels(:)) < int_thresh
            prom_pixels = cp_roi_promvals(roi_i).PixelValues;
            if mean(prom_pixels(:)) < prom_thresh
                cp_masks3(cp_rois(roi_i).PixelIdxList) = 0;
            end
        end
    end
    
    %% Check cp masks (debugging)
    cp_over3 = labeloverlay(th_img_a, cp_masks3);
        
    %% Show Result
    if show_result == 1
        figure('Name', [file_list{i}])
        imshow(cp_over3)
    end
    
    %% Save Result
    imwrite(cp_masks3, [base_dir img_folder file_list{i} '_cp_masks.png'])
end

