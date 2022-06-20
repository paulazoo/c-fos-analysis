
mouse = 'PZ9';

base_dir = 'E:\histology\paula\cellpose_data_copied\';

for img_num = 6:1:9
%% loading images/masks
cfos_img = imread([base_dir 'paula_cFos16\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped.tif']);
load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'], 'tissue_mask')
th_cp_masks = imread([base_dir 'paula_TH22\' mouse '\C1_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
th_cp_edges = bwperim(th_cp_masks);
% cfos_img_a = imadjust(cfos_img);

% im_out = cat(3, cfos_img, th_cp_edges);

out_dir = 'E:\histology\paula\cellpose_data_copied\mating\';

imwrite(cfos_img, [out_dir mouse '_' int2str(img_num) '.tif'], 'tiff')

imwrite(th_cp_edges, [out_dir mouse '_' int2str(img_num) '.tif'], 'tiff', 'writemode', 'append')
end

%%
mouse = 'PZ8';

base_dir = 'E:\histology\paula\cellpose_data_copied\';

for img_num = 6:1:9
cfos_img = imread(['C:\Users\paulazhu\Downloads\cellpose_data_copied\cont_bwperim\' mouse '_' int2str(img_num) '.tif']);

cfos_img = imadjust(cfos_img);

cfos_img = im2uint8(cfos_img);

th_cp_masks = imread(['C:\Users\paulazhu\Downloads\cellpose_data_copied\cont_bwperim\' mouse '_' int2str(img_num) '.tif'], 2);

th_cp_masks = imfill(th_cp_masks, 'holes');

se = strel('disk', 2);
th_cp_masks = imdilate(th_cp_masks, se);

th_cp_masks = edge(th_cp_masks);

im_over = imoverlay(cfos_img, th_cp_masks, [1, 0, 0]);

out_dir = 'C:\Users\paulazhu\Downloads\cellpose_data_copied\cont_edge_1ch\' ;

imwrite(im_over, [out_dir mouse '_' int2str(img_num) '.tif'], 'tiff')
end