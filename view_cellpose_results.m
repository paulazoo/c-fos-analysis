figure(2)
hold on
%% User input
[imgfile, imgpath] = uigetfile('.tif', 'img', 'E:\histology\paula\cellpose_data_copied\220830paula_CFOS');
[masksfile, maskspath] = uigetfile('.png', 'masks', 'E:\histology\paula\cellpose_data_copied\220830paula_CFOStest3');

% [masksfile2, maskspath2] = uigetfile('.png', 'masks', 'E:\histology\paula\cellpose_data_copied\220830paula_CFOS');
% 
% [masksfile3, maskspath3] = uigetfile('.png', 'masks', 'E:\histology\paula\cellpose_data_copied\220830paula_CFOS');
% 
% [masksfile4, maskspath4] = uigetfile('.png', 'masks', 'E:\histology\paula\cellpose_data_copied\220830paula_CFOS');

%% Get image
img = imread([imgpath imgfile]);
img_a = imadjust(img);

%% Get masks
masks = imread([maskspath masksfile]);
% masks2 = imread([maskspath2 masksfile2]);
% masks3 = imread([maskspath3 masksfile3]);
% masks4 = imread([maskspath4 masksfile4]);
% masks = masks + masks2 + masks3 + masks4;

%% Show overlay
imover = labeloverlay(img_a, masks);
imshow(imover)
