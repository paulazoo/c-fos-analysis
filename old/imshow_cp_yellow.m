function imshow_cp_yellow(mouse, img_num, cfos_batch, th_batch)
    % no ln compatability yet
    base_dir = 'E:\histology\paula\cellpose_data_copied\';
    
    % read in images
    cfos_cp = imread([base_dir cfos_batch '\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
    
    th_cp = imread([base_dir th_batch '\' mouse '\C1_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
    
    [M, N] = size(cfos_cp);
    
    total_cp = zeros(M, N, 3);
    total_cp(:, :, 1) = cfos_cp;
    total_cp(:, :, 2) = th_cp;
    
    figure('Name', [mouse '_' int2str(img_num)])
    imshow(total_cp)
end