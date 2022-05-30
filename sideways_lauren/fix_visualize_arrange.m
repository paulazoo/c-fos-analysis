mouse = 'PZ22';

for i = 1:16
    img = imread(['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(i) '.tif']);
    adjusted_img = imadjust(img);
    figure('Name', [mouse '_' int2str(i)], 'Position', [500, 500, 100, 100])
    imshow(adjusted_img)
end