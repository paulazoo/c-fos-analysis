base_dir = 'E:\histology\paula\cellpose_data_copied\';

mouse = 'PZ9';
img_num = 9;
img = imread([base_dir 'paula_cFos16\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped.tif']);

lut_img = imadjust(img,[],[],1.5);
