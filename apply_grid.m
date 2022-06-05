function apply_grid(mouse, img_num, batch, cp_type)
    if strcmp(cp_type, 'THln')
        channel_num = 1;
    elseif strcmp(cp_type, 'TH')
        channel_num = 1;
    elseif strcmp(cp_type, 'cFos')
        channel_num = 2;
    end
    
    % load mask file
    load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_grid_cropped.mat'])
    % load tissuemask file
    load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'])
    
    % load batch output
    cp_mask = imread(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' img_num '_cropped_cp_masks.png']);

    [M, N] = size(masks);
    % loop through all the grid section masks
    for i = 1:1:N
        % get grid mask and just really make sure its logical (1 or 0)
        grid_mask = logical(masks{i});
        % ignore non-tissue regions
        grid_mask(tissue_mask == 0) = 0;

        % get area of mask region
        mask_area = sum(grid_mask(:));
        % mask area can be big with larger pixel x pixel
        mask_area = mask_area / 1000;
        % disp(['Mask Area: ' num2str(mask_area)])
        mask_out = cp_mask;
        mask_out(grid_mask == 0) = 0;
        % count connected components
        cfos_comps = bwconncomp(mask_out);
        num_cells = cfos_comps.NumObjects;
        cell_freq = num_cells / mask_area;
        % disp(['Num Cells: ' int2str(num_cells)])
        % disp(['Cell Freq: ' num2str(cell_freq)])

        save(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\' mouse '_' int2str(img_num) '_grid' int2str(i)], ...
            'cfos_thresh4', 'mask', 'cfos_comps', 'mask_area', 'num_cells', 'cell_freq')

    end