% NOT DONE
function apply_grid(mouse, img_num, batch)
    % load mask file
    load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_grid_cropped.mat'])
    % load tissuemask file
    load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'])
    
    % load batch output
    cp_output = imread(['F:\analysis\paula\cellpose_data\' batch '\' mouse '\C2_' mouse '_' img_num '_cropped_cp_masks.png']);

    [M, N] = size(masks);
    % loop through all the grid section masks
    for i = 1:1:N
        mask = masks{i};
        % ignore non-tissue regions
        mask(tissue_mask == 0) = 0;

        % get area of mask region
        mask_area = sum(mask(:));
        % mask area can be big with larger pixel x pixel
        mask_area = mask_area / 1000;
        % disp(['Mask Area: ' num2str(mask_area)])
        mask_cfos = cfos_thresh4;
        mask_cfos(mask == 0) = 0;
        % count connected components
        cfos_comps = bwconncomp(cfos_thresh4);
        num_cells = cfos_comps.NumObjects;
        cell_freq = num_cells / mask_area;
        % disp(['Num Cells: ' int2str(num_cells)])
        % disp(['Cell Freq: ' num2str(cell_freq)])

        save(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_' names_key{i} '_cfos'], ...
            'cfos_thresh4', 'mask', 'cfos_comps', 'mask_area', 'num_cells', 'cell_freq')

    end