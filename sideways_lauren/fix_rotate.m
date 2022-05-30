mouse = 'PZ22';
for i = 1:16
   img = imread(['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(i) '.tif']);
   img_r = imrotate(img, 180);
   imwrite(img_r, ['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(i) '.tif'])
   
   img = imread(['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(i) '.tif']);
   img_r = imrotate(img, 180);
   imwrite(img_r, ['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(i) '.tif'])
end