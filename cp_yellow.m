function cp_yellow(mouse)

    base_dir = 'E:\histology\paula\cellpose_data_copied\';
    cfos_batch = 'paula_cFosCombined';
    th_batch = 'paula_TH22';
    mkdir([base_dir 'paula_yellow\'], mouse)
    
    total_imgs = 16;
    if strcmp(mouse, 'PZ19')
        total_imgs = 14;
    end
    
    yellow_data = cell(total_imgs, 2);

    for img_num = 1:1:total_imgs
        % read in images
        cfos_cp = imread([base_dir cfos_batch '\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
        cfos_cp = logical(cfos_cp);

        th_cp = imread([base_dir th_batch '\' mouse '\C1_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
        th_cp = logical(th_cp);

        th_cp(cfos_cp == 0) = 0;

        yellow_cp = cfos_cp + th_cp;
        rois = regionprops(cfos_cp, yellow_cp, "PixelValues");
        roi_pixels = regionprops(cfos_cp, "PixelIdxList");
        [M, N] = size(rois);

        yellow_count = 0;
        yellow_png = zeros(size(cfos_cp));
        for i = 1:1:M
            roi_values = rois(i).PixelValues;
            min10 = prctile(roi_values, 10);
            if min10 == 2
                yellow_count = yellow_count + 1;
                yellow_png(roi_pixels(i).PixelIdxList) = 1;
            end
        end
        imwrite(yellow_png, [base_dir 'paula_yellow\' mouse '\C4_' mouse '_' int2str(img_num) '_cropped_cp_masks.png'])
    end
end

