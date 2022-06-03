function imshow_cellpose(mouse, img_num, batch, cp_type)
    if strcmp(cp_type, 'THln')
        channel_num = 1;
        ln = 1;
    elseif strcmp(cp_type, 'TH')
        channel_num = 1;
        ln = 0;
    elseif strcmp(cp_type, 'cFos')
        channel_num = 2;
        ln = 0;
    end
    
    % read in image
    if ln == 1
        cp_img = imread(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_ln_cp_masks.png']);
    else
        cp_img = imread(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
    end
    cp_img_a = cp_img;
    cp_img_a(cp_img_a > 0) = 1;
    cp_perim = bwperim(cp_img_a);
    
    % read in image
    if ln == 1
        img = imread(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_ln.tif']);
    else
        img = imread(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped.tif']);
    end
    img_a = imadjust(img);
    
    cp_overlay = imoverlay(img_a, cp_perim, [1 0.1 .1]);
    
    figure('Name', [mouse '_' int2str(img_num)])
    imshow(cp_overlay)
end