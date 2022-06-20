function [cent, cent_map, yellow_png] = find_cfos_peaks(mouse, batch_name)

mouse = 'PZ5';

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';
img_folder = [mouse '\'];

file_list = dir([base_dir img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

with_th = 1;

for i = 12:1:length(file_list)
    %% Load image
    th_img = imread([base_dir img_folder file_list{i} '.tif']);

    %% Load cp masks
    cp_masks = imread([base_dir img_folder file_list{i} '_cp_masks.png']);
    cp_masks1 = cp_masks;
    
%% c-Fos

cfos_img2 = cfos_img;
cfos_img2(tissue_mask == 0) = 0;

gausssizes = [20, 64];
medsizes = [2, 2];
% 2D filter
cfos_img2 = medfilt2(cfos_img2, medsizes, 'symmetric');
        
% gaussian normalize
f_prime = single(cfos_img2)-single(imgaussfilt(single(cfos_img2),gausssizes(1)));
ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
ln_img(isnan(ln_img)) = 0;

% ln_thresh = (max([min(max(ln_img2,[],1))  min(max(ln_img2,[],2))]));
ln_thresh  = prctile(ln_img(:), 90);
% disp(ln_thresh)
ln_img2 = ln_img;
ln_img2(ln_img2 < ln_thresh) = 0;
ln_img2 = logical(ln_img2);

thres = (max([min(max(cfos_img2,[],1))  min(max(cfos_img2,[],2))]));
filt = (fspecial('gaussian', 24,1)); %if needed modify the filter according to the expected peaks sizes

cfos_img2 = medfilt2(cfos_img2,[3,3]);
cfos_img2=cfos_img2.*uint16(cfos_img2>thres);
% smooth image
cfos_img2=conv2(single(cfos_img2),filt,'same') ;
% Apply again threshold (and change if needed according to SNR)
cfos_img2=cfos_img2.*(cfos_img2>0.9*thres);

% d will be noisy on the edges, and also local maxima looks
% for nearest neighbors so edge must be at least 1. We'll skip 'edge' pixels.
edg = 3;
sd=size(cfos_img2);
[x, y]=find(cfos_img2(edg:sd(1)-edg,edg:sd(2)-edg));

% initialize outputs
cent=[];%
cent_map=zeros(sd);

x=x+edg-1;
y=y+edg-1;
for j=1:length(y)
    if (cfos_img2(x(j),y(j))>cfos_img2(x(j)-1,y(j)-1 )) &&...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j)-1,y(j))) &&...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j)-1,y(j)+1)) &&...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j),y(j)-1)) && ...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j),y(j)+1)) && ...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j)+1,y(j)-1)) && ...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j)+1,y(j))) && ...
            (cfos_img2(x(j),y(j))>cfos_img2(x(j)+1,y(j)+1));

        cent = [cent ;  y(j) ; x(j)];
        cent_map(x(j),y(j))=cent_map(x(j),y(j))+1; % if a binary matrix output is desired

    end
end

cent_map(ln_img2 == 0) = 0;


%% out of TH masks
if with_th == 1
%     se = strel('disk', 1, 0); % Make round structuring element.
%     th_cp_masks2 = imerode(th_cp_masks, se);
    th_cp_masks2 = th_cp_masks;
    
    rois = regionprops(th_cp_masks2, cent_map, "PixelValues");
    roi_pixels = regionprops(th_cp_masks2, "PixelIdxList");
    [M, N] = size(rois);
    
    yellow_count = 0;
    yellow_png = zeros(size(cfos_img));
    for i = 1:1:M
        roi_values = rois(i).PixelValues;
        roi_max = max(roi_values(:));
        if roi_max > 0
            yellow_count = yellow_count + 1;
            yellow_png(roi_pixels(i).PixelIdxList) = 1;
        end
    end
%     disp(['yellow_count: ' int2str(yellow_count)])
%     disp(['th_count: ' int2str(M)])
%      disp([mouse '_' int2str(img_num) ' cfos/th: ' num2str(yellow_count/M)])
end
imwrite(yellow_png, [base_dir batch_name '\' mouse '\C4_' mouse '_' int2str(img_num) '_cropped_cp_masks.png'])

end
end
