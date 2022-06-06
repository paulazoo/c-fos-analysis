function grid_data = apply_grid(mouse, batch, cp_type)
    if strcmp(cp_type, 'THln')
        channel_num = 1;
    elseif strcmp(cp_type, 'TH')
        channel_num = 1;
    elseif strcmp(cp_type, 'cFos')
        channel_num = 2;
    end
    total_imgs = 14;
    total_grid_sections = 6;
    
    grid_data = cell((total_grid_sections*total_imgs), 4);
    for img_num = 1:1:total_imgs
    
        % load mask file
        load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_grid.mat'])
        % load tissuemask file
        load(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'])

        % load batch output
        cp_mask = imread(['E:\histology\paula\cellpose_data_copied\' batch '\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);

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
            mask_area = mask_area .* (0.645 .^ 2); % 1 pixel per 0.645 um
            % disp(['Mask Area: ' num2str(mask_area)])
            mask_out = cp_mask;
            mask_out(grid_mask == 0) = 0;
            % count connected components
            cfos_comps = bwconncomp(mask_out);
            % in the future, edit to include connected but separate (NOT DONE)
            num_cells = cfos_comps.NumObjects;
            cell_freq = num_cells / mask_area;
            % disp(['Num Cells: ' int2str(num_cells)])
            % disp(['Cell Freq: ' num2str(cell_freq)])

            section_name = names_key{i};
            grid_data{((img_num-1) * total_grid_sections) + i, 1} = [mouse '_' int2str(img_num)];
            grid_data{((img_num-1) * total_grid_sections) + i, 2} = section_name;
            grid_data{((img_num-1) * total_grid_sections) + i, 3} = num_cells;
            grid_data{((img_num-1) * total_grid_sections) + i, 4} = cell_freq;
        end
    end
    save(['E:\histology\paula\cellpose_data_copied\' batch '\' mouse '\' mouse '_' int2str(img_num) '_griddata'], 'grid_data')

    
end