function find_cfos_peaks(mouse, start_file, end_file)
%% Params
mouse = 'PZ39';
% start_file = 13;
% end_file = 16;

cfos_dir = 'E:\histology\paula\';
img_folder = [mouse '\cropped\'];
cfos_channel_num = '2';

show_results = 0;

file_list = dir([cfos_dir img_folder 'C' cfos_channel_num '_*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

%% Peak finding params
peak_diameter = 12;
diameter_multiplier = 300;
medsizes = [3, 3];
ln_thresh_percentile = 90;
int_thresh_percentile = 30;

%% Tissuemask Params
subtract_tissuemask = 0;
tissuemask_dir = 'E:\histology\paula\';
tissuemask_folder = [mouse '_tissuemask\'];

tissuemaskfile_list = dir([tissuemask_dir tissuemask_folder '*.mat']);
tissuemaskfile_list = {tissuemaskfile_list.name};
tissuemaskfile_list = strrep(tissuemaskfile_list, '.mat', '');

%% With TH option
with_th = 1;
yellow_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_yellow\';

th_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH23\';
th_img_folder = [mouse '\'];

thfile_list = dir([th_dir img_folder '*.tif']);
thfile_list = {thfile_list.name};
thfile_list = strrep(thfile_list, '.tif', '');

%% Make New Folders
if with_th == 1
    mkdir(yellow_dir, mouse);
end
mkdir(cfos_dir, [mouse '_cfospeaks'])

for i = start_file:1:end_file
    tic
    %% Load c-Fos image
    cfos_img = imread([cfos_dir img_folder file_list{i} '.tif']);

    %% Load TH cp masks
    if with_th == 1
        th_cp_masks = imread([th_dir th_img_folder thfile_list{i} '_cp_masks.png']);
    end
    
    %% Get Tissuemask
    if subtract_tissuemask == 1
        % load tissuemask mat file
        load([tissuemask_dir tissuemask_folder tissuemaskfile_list{i} '.mat'], 'tissue_mask')
    end
    
    %% Get rid of noise
    cfos_img2 = cfos_img;
    
    cfos_img2 = medfilt2(cfos_img2, medsizes, 'symmetric'); % 2D Median filter
    
     %% Local Normalize
    gausssizes = [peak_diameter, peak_diameter*diameter_multiplier];

    % gaussian normalize
    f_prime = single(cfos_img2)-single(imgaussfilt(single(cfos_img2),gausssizes(1)));
    ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
    ln_img(isnan(ln_img)) = 0;
    
    %% Local Normalize Threshold
    ln_thresh  = prctile(ln_img(:), ln_thresh_percentile);
    ln_thresh_img = logical(ln_img > ln_thresh);
    ln_thresh_img = bwareaopen(ln_thresh_img, 50);
    ln_thresh_img = imfill(ln_thresh_img ,'holes');
    se = strel('disk', 2);
    ln_thresh_img = imdilate(ln_thresh_img, se);
    
    %% Intensity Threshold
    int_thresh  = prctile(cfos_img2(:), int_thresh_percentile);
    int_thresh_img = logical(cfos_img2 > int_thresh);
    
    %% Local Normalize + Tissuemask Filter
    total_filt = ln_thresh_img;
    if subtract_tissuemask == 1
        total_filt(tissue_mask == 0) = 0;
    end
    total_filt(int_thresh_img == 0) = 0;
    cfos_img3 = cfos_img2;
    cfos_img3(total_filt == 0) = 0;
    
    %% gaussian smooth image
    filt = (fspecial('gaussian', peak_diameter, 1)); %if needed modify the filter according to the expected peaks sizes
    cfos_img4=conv2(single(cfos_img3),filt,'same');
    
    %% Local Maxima
    peaks_img = cfos_img4;
    % d will be noisy on the edges, and also local maxima looks
    % for nearest neighbors so edge must be at least 1. We'll skip 'edge' pixels.
    edg = 3;
    sd=size(peaks_img);
    [x, y]=find(peaks_img(edg:sd(1)-edg,edg:sd(2)-edg));

    % initialize outputs
%     cent=[];%
    cent_map=zeros(sd);

    x=x+edg-1;
    y=y+edg-1;
    for j=1:length(y)
        if (peaks_img(x(j),y(j))>peaks_img(x(j)-1,y(j)-1 )) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-1,y(j))) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-1,y(j)+1)) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j),y(j)-1)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j),y(j)+1)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+1,y(j)-1)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+1,y(j))) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+1,y(j)+1)) && ...
                ...
                ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-2,y(j))) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-2,y(j)+1)) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-2,y(j)-1)) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+2,y(j))) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+2,y(j)+1)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+2,y(j)-1)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j),y(j)-2)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+1,y(j)-2)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-1,y(j)-2)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j),y(j)+2)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+1,y(j)+2)) && ...
                (peaks_img(x(j),y(j))>peaks_img(x(j)+2,y(j)+2)) && ... 
                (peaks_img(x(j),y(j))>peaks_img(x(j)+2,y(j)-2)) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-2,y(j)+2)) &&...
                (peaks_img(x(j),y(j))>peaks_img(x(j)-2,y(j)-2))

%             cent = [cent ;  y(j) ; x(j)];
            cent_map(x(j),y(j))=cent_map(x(j),y(j))+1; % if a binary matrix output is desired

        end
    end
    
    %% Subtract tissuemask file if needed
    if subtract_tissuemask == 1
        th_cp_masks(tissue_mask == 0) = 0;
        cent_map(tissue_mask == 0) = 0;
    end
    
    se = strel('disk', 1); % for dilating nuclei peaks
    cent_map2 = imdilate(cent_map, se);
    cent_map3 = logical(cent_map2);
    toc
    %% Calculate TH cells w c-Fos
    if with_th == 1
        rois = regionprops(th_cp_masks, cent_map, "PixelValues");
        roi_pixels = regionprops(th_cp_masks, "PixelIdxList");
        [M, N] = size(rois);

        yellow_count = 0;
        yellow_png = zeros(size(cfos_img));
        for roi_i = 1:1:M
            roi_values = rois(roi_i).PixelValues;
            roi_max = max(roi_values(:));
            if roi_max > 0
                yellow_count = yellow_count + 1;
                yellow_png(roi_pixels(roi_i).PixelIdxList) = yellow_count;
            end
        end
        yellow_png = uint16(yellow_png);
    end
        
    if show_results == 1
        %% Show Peaks Results Overlay
        cfos_img_a = imadjust(cfos_img);
        cfos_over = imoverlay(cfos_img_a, cent_map2, [0.1, 1, 0.1]);
        figure('Name', 'c-Fos Peaks')
        imshow(cfos_over)

        %% Display Results
        if with_th == 1
            disp(['yellow_count: ' int2str(yellow_count)])
            disp(['th_count: ' int2str(M)])
            disp(['cfos/th: ' num2str(yellow_count/M)])
        end

        %% Show cfos/th Results Overlay
        if with_th == 1
            th_perim = bwperim(th_cp_masks);
            yellow_perim = bwperim(yellow_png);
            res_over1 = imoverlay(cfos_img_a, th_perim, [1, 0.1, 0.1]);
            res_over2 = imoverlay(res_over1, yellow_perim, [0.1, 1, 0.1]);
            figure('Name', 'th/cfos overlay')
            imshow(res_over2)
        end

        %% Show Filter Results Overlay
        filt_perim = bwperim(total_filt);
        ln_over = imoverlay(cfos_img_a, logical(filt_perim), [0.1, 1, 0.1]);
        figure; imshow(ln_over)
    end
    
    %% Get img_num
    split_filename = split(file_list{i}, '_');
    img_num_str = split_filename(3, 1);
    img_num_str = img_num_str{1};
    
    %% Write Yellow Results
    if with_th == 1
        imwrite(yellow_png, [yellow_dir mouse '\C4_' mouse '_' img_num_str '.png'])
    end
    
    imwrite(cent_map3, [cfos_dir mouse '_cfospeaks\C2_' mouse '_' img_num_str '.png'])

end
end
