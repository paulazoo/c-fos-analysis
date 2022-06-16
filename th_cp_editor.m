
mouse = 'PZ5';

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH14\';
cp_diameter = 14;
img_folder = [mouse '\'];
ln_folder = [mouse '_ln\'];

file_list = dir([base_dir img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

for i = 1:1:length(file_list)
    %% Load image
    th_img = imread([base_dir img_folder file_list{i} '.tif']);

    %% Load ln image
    ln_img = imread([base_dir ln_folder file_list{i} '_ln.tif']);
    ln_img_a = imadjust(ln_img);
    
    %% Load cp masks
    cp_masks = imread([base_dir img_folder file_list{i} '_cp_masks.png']);
    cp_masks1 = cp_masks;
    
    %% Show cp masks on adjusted image
    th_img_a = imadjust(th_img);
    cp_over = labeloverlay(th_img_a, cp_masks1);
    imshow(cp_over)
    
    %% Manual Editing
    
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
        % 104 h
        
        keyvalue = double(get(gcf,'CurrentCharacter'));
        % disp(value)
        if keyvalue == 100
            % 100 = d = delete
            h = imfreehand(gca);
            delete_region = createMask(h);
            cp_masks1(delete_region) = 0;
            cp_over = labeloverlay(th_img_a, cp_masks1);
            disp('ROIs in selected region deleted.')
            keyvalue = 32;
            imshow(cp_over)
            
        elseif keyvalue == 97
            % 97 = a = add
            h = imfreehand(gca);
            add_roi = createMask(h);
            max_roi_idx = max(cp_masks1(:));
            cp_masks1(add_roi) = (max_roi_idx + 1);
            cp_over = labeloverlay(th_img_a, cp_masks1);
            disp('ROI added.')
            keyvalue = 32;
            imshow(cp_over)
            
        elseif keyvalue == 31
            % 31 = down arrow = show ln image in region
            h = imfreehand(gca);
            ln_roi = createMask(h);
            th_img_a(ln_roi) = ln_img_a(ln_roi);
            cp_over = labeloverlay(th_img_a, cp_masks1);
            disp('Showing local normalization in region.')
            keyvalue = 32;
            imshow(cp_over)
            
        elseif keyvalue == 30
            % 30 = up arrow = show original th img
            th_img_a = imadjust(th_img);
            cp_over = labeloverlay(th_img_a, cp_masks1);
            disp('Showing original image.')
            keyvalue = 32;
            imshow(cp_over)
            
        elseif keyvalue == 104
            % 104 = h = hide masks in region
            h = imfreehand(gca);
            hide_roi = createMask(h);
            cp_masks_hide = cp_masks1;
            cp_masks_hide(hide_roi) = 0;
            cp_over = labeloverlay(th_img_a, cp_masks_hide);
            disp('Hiding masks in region.')
            keyvalue = 32;
            imshow(cp_over)
            
        elseif keyvalue == 117
            % 117 = u = unhide all masks
            cp_over = labeloverlay(th_img_a, cp_masks1);
            disp('Showing original image.')
            keyvalue = 32;
            imshow(cp_over)            
            
        elseif keyvalue == 112
            % 112 = p = save
            
            % Area filter before saving
            cp_rois = regionprops(cp_masks1, "Area", "PixelIdxList");
            [M, N] = size(cp_rois);
            for roi_i = 1:1:M
                if cp_rois(roi_i).Area < 50
                    cp_masks1(cp_rois(roi_i).PixelIdxList) = 0;
                end
            end
            
            imwrite(cp_masks1, [base_dir img_folder file_list{i} '_cp_masks.png'])
            disp(['Mask saved to ' base_dir img_folder file_list{i} '_cp_masks.png'])
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

