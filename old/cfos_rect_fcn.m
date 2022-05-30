function cfos_rect_fcn(mouse, img_num)
    region_name = 'rect';

    % read in image
    cfos_img = imread(['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(img_num) '.tif']);
    % adjusted_cfos = imadjust(cfos_img);

    load(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_tissuemask.mat'])
    
    % load mask file
    % [file,path] = uigetfile('*.mat', 'Select Mask Matlab File');
    % load([path file])
    load(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_' region_name '_mask.mat'])

    [M, N] = size(masks);   
    for i = 1:1:N
        mask = masks{i};

        % only analyze actual brain slice tissue
        mask(tissue_mask == 0) = 0;

        % get area of mask region
        mask_area = sum(mask(:));
        % mask area can be big with larger pixel x pixel
        mask_area = mask_area / 1000;
    %     disp(['Mask Area: ' num2str(mask_area)])
        % get only image values in the mask
        cfos_masked = cfos_img;
        cfos_masked(mask == 0) = 0;

        cfos_mode = mode(cfos_masked(cfos_masked~=0));
    %     disp(['Mode: ' int2str(cfos_mode)])
        max99 = prctile(cfos_img(cfos_img~=0), 99);
    %     disp(['Max: ' int2str(max99)])

        % threshold
        thresh_value = (max99 - cfos_mode)*0.5 + cfos_mode;
        cfos_thresh = cfos_masked > thresh_value;

        cfos_thresh2 = imfill(cfos_thresh,'holes');
        cfos_thresh3 = imopen(cfos_thresh2, ones(5,5));
        cfos_thresh4 = bwareaopen(cfos_thresh3, 50);
        cfos_thresh4_perim = bwperim(cfos_thresh4);
        % overlay1 = imoverlay(adjusted_cfos, cfos_thresh4_perim, [1 0.1 .1]);
        % figure
        % imshow(overlay1)

        % count connected components
        cfos_comps = bwconncomp(cfos_thresh4);
        num_cells = cfos_comps.NumObjects;
        cell_freq = num_cells / mask_area;
    %     disp(['Num Cells: ' int2str(num_cells)])
    %     disp(['Cell Freq: ' num2str(cell_freq)])

        save(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_' names_key{i} '_cfos'], ...
            'cfos_thresh4', 'mask', 'cfos_comps', 'mask_area', 'num_cells', 'cell_freq')

    end
end