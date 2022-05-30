
prompt = {'Mouse:','Image Number:', 'Region Mask Name:'};
default_input = {'PZ', '1', ''};
answer = inputdlg(prompt,'Analysis Properties',[1 50], default_input);

mouse = answer{1};
img_num = str2num(answer{2});
region_name = answer{3};

% read in image
cfos_img = imread(['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(img_num) '.tif']);

% load mask file
% [file,path] = uigetfile('*.mat', 'Select Mask Matlab File');
% load([path file])
load(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_' region_name '_mask.mat'])
% get area of mask region
mask_area = sum(mask(:)==1);
% mask area can be big with larger pixel x pixel
mask_area = mask_area / 1000;
disp(mask_area)
% get only image values in the mask
cfos_masked = cfos_img;
cfos_masked(mask == 0) = 0;
adjusted_cfos = imadjust(cfos_img);

cfos_mode = mode(cfos_masked(cfos_masked~=0));
max99 = prctile(cfos_img(cfos_img~=0), 99);

% threshold
thresh_value = (max99 - cfos_mode)*0.5 + cfos_mode;
cfos_thresh = cfos_masked > thresh_value;

cfos_thresh2 = imfill(cfos_thresh,'holes');
cfos_thresh3 = imopen(cfos_thresh2, ones(5,5));
cfos_thresh4 = bwareaopen(cfos_thresh3, 50);
cfos_thresh4_perim = bwperim(cfos_thresh4);
overlay1 = imoverlay(adjusted_cfos, cfos_thresh4_perim, [1 0.1 .1]);
figure
imshow(overlay1)

% count connected components
cfos_comps = bwconncomp(cfos_thresh4);
num_cells = cfos_comps.NumObjects;
disp(num_cells)
cell_freq = num_cells / mask_area;

save(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_' region_name '_cfos'], ...
    'cfos_thresh4', 'mask', 'cfos_comps', 'mask_area', 'num_cells', 'cell_freq')



