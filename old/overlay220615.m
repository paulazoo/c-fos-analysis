
mouse = 'PZ9';

base_dir = 'E:\histology\paula\cellpose_data_copied\';

for img_num = 6:1:9
%% loading images/masks
cfos_img = imread([base_dir 'paula_cFos16\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped.tif']);
load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'], 'tissue_mask')
th_cp_masks = imread([base_dir 'paula_TH22\' mouse '\C1_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);

cfos_img_a = imadjust(cfos_img);

over_out = imoverlay(cfos_img_a, th_cp_masks, [1 0.1 0.1]);

out_dir = 'E:\histology\paula\cellpose_data_copied\mating_adjusted\';

imwrite(over_out, [out_dir mouse '_' int2str(img_num) '.tif'], 'tiff')
end