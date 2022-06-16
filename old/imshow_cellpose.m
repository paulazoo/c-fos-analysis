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
    elseif strcmp(cp_type, 'yellow')
        channel_num = 4;
        ln = 0;
    end
    base_dir = 'E:\histology\paula\cellpose_data_copied\';
    
    % read in image
    if ln == 1
        cp_img = imread([base_dir batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_ln_cp_masks.png']);
    else
        cp_img = imread([base_dir batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
    end
    cp_img_a = cp_img;
    cp_img_a(cp_img_a > 0) = 1;
    cp_perim = bwperim(cp_img_a);
    
    % read in image
    if strcmp(cp_type, 'yellow')
        img = imread([base_dir 'paula_TH22\' mouse '\C1_' mouse '_' int2str(img_num) '_cropped.tif']);
    elseif strcmp(batch, 'paula_cFosCombined')
        img = imread([base_dir 'paula_cFos16\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped.tif']);
    elseif ln == 1
        img = imread([base_dir batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_ln.tif']);
    else
        img = imread([base_dir batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped.tif']);
    end
    img_a = imadjust(img);
    
    cp_overlay = imoverlay(img_a, cp_perim, [1 0.1 .1]);
    
    figure('Name', [mouse '_' int2str(img_num)])
    imshow(cp_overlay)
end