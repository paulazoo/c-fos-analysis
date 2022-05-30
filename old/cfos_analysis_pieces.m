%%
mouse = 'PZ5'
img_num = 1
region_name = 'AVPVPVpo'

%%
% read in image
th_img = imread(['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(img_num) '.tif']);
cfos_img = imread(['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(img_num) '.tif']);

%%
% create mask for analysis region
adjusted_th_img = imadjust(th_img);
imshow(adjusted_th_img)
hFH = imfreehand();
% Create a binary image ("mask") from the ROI object
mask = hFH.createMask();
adjusted_cfos_img = imadjust(cfos_img);

%%
% get area of mask region
mask_area = sum(mask(:)==1);
% mask area can be big with larger pixel x pixel
mask_area = mask_area / 1000;
disp(mask_area)
% get only image values in the mask
cfos_masked = cfos_img;
cfos_masked(mask == 0) = 0;


%%
cfos_mode = mode(cfos_masked(cfos_masked~=0));
max95 = prctile(cfos_masked(cfos_masked~=0), 95);
% threshold
thresh_value = (max95 - cfos_mode)*0.6 + cfos_mode;
cfos_thresh = cfos_masked > thresh_value;

%%
cfos_thresh2 = imfill(cfos_thresh,'holes');
cfos_thresh3 = imopen(cfos_thresh2, ones(5,5));
cfos_thresh4 = bwareaopen(cfos_thresh3, 40);
cfos_thresh4_perim = bwperim(cfos_thresh4);
overlay1 = imoverlay(adjusted_cfos_img, cfos_thresh4_perim, [1 0.1 .1]);
imshow(overlay1)

% %%
% adjusted_cfos_mask = adjusted_cfos_img;
% adjusted_cfos_mask(mask == 0) = 0;
% mask_em = imextendedmax(adjusted_cfos_mask, 30);
% %overlay1 = imoverlay(adjusted_cfos_img, mask_em, [1 0.1 .1]);
% %figure(2)
% %imshow(overlay1)
% 
% %%
% mask_em = bwareaopen(mask_em, 3);
% mask_em = imclose(mask_em, ones(5,5));
% mask_em = bwareaopen(mask_em, 20);
% mask_em = imfill(mask_em, 'holes');
% % overlay2 = imoverlay(adjusted_cfos_img, cfos_thresh4_perim | mask_em, [1 0.1 1]);
% % figure(3)
% % imshow(overlay2)
% 
% %%
% adjusted_cfos_c = imcomplement(adjusted_cfos_img);
% cfos_mod = imimposemin(adjusted_cfos_c, ~cfos_thresh4 | mask_em);
% 
% %%
% L = watershed(cfos_mod);
% % imshow(label2rgb(L))
% 
% % overlay3 = imoverlay(adjusted_cfos_img, L, [1 0.1 1]);
%%
% count connected components
cfos_comps = bwconncomp(cfos_thresh4);
num_cells = cfos_comps.NumObjects;
disp(num_cells)
cell_freq = num_cells / mask_area;

%%
save(['E:\histology\paula\' mouse '\' mouse '_' image_num '_' region_name '_cfos'], 'cfos_thresh4', 'mask', 'cfos_comps', 'cell_freq')



