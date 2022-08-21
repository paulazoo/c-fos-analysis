function apply_grid(mouse)

%% Params
% mouse = 'PZ8';
start_file = 1;
end_file = 1;

img_dir = 'E:\histology\paula\cellpose_data_copied\paula_cFos16\';
img_folder = [mouse '_cfospeaks\'];

grid_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';
grid_folder = [mouse '_grid\'];

file_list = dir([img_dir img_folder '*.png']);
file_list = {file_list.name};
file_list = strrep(file_list, '.png', '');
end_file = length(file_list)

gridfile_list = dir([grid_dir grid_folder '*.mat']);
gridfile_list = {gridfile_list.name};
gridfile_list = strrep(gridfile_list, '.mat', '');

%% Output Dir
mkdir(img_dir, [mouse '_griddata'])

%% Initialize grid_data and totalgrid_data vars
grid_data = cell(12* (end_file - start_file + 1), 5);
totalgrid_data = cell(end_file - start_file + 1, 5);

%% Loop through images
for i = start_file:1:end_file
    %% Load masks image
    img = imread([img_dir img_folder file_list{i} '.png']);
    
    %% Load grid masks
    load([grid_dir grid_folder gridfile_list{i} '.mat'], 'masks', 'names_key');
    grid_masks = masks;
    
    %% Get img_num
    file_split = split(file_list{i}, '_');
    img_num_str = file_split{3};
    
    %% Initialize total grid area mask
    totalgrid_mask = grid_masks{1};
    totalgrid_mask_area = 0;
    
    %% Loop through all the grid section masks
    for j = 1:1:length(grid_masks)
        grid_mask = grid_masks{j};
        
        %% Get mask area
        mask_area = sum(grid_mask(:));
        % mask area can be big with larger pixel x pixel
        mask_area = mask_area .* (0.645 .^ 2); % 1 pixel per 0.645 um, this is in um^2
        mask_area = mask_area / (100 .^ 2); % cell freq is in terms of every 100 um^2
        img_out = img;
        img_out(grid_mask == 0) = 0;
        
        %% Totalgrid
        totalgrid_mask(grid_mask == 1) = 1;
        totalgrid_mask_area = totalgrid_mask_area + mask_area;
        
        %% Num cells
        cell_rois = regionprops(img_out, 'Area');
        cell_rois = cell2mat(struct2cell(cell_rois));
        cell_rois = cell_rois(cell_rois > 0);
        
        [M, num_cells] = size(cell_rois);
        cell_freq = num_cells / mask_area;
        
        %% Get next empty row (MATLAB traverses down each column in order)
        next_row = find(cellfun('isempty', grid_data), 1);
        
        %% Input into grid data
        section_name = names_key{j};
        grid_data{next_row, 1} = [mouse '_' img_num_str];
        grid_data{next_row, 2} = section_name;
        grid_data{next_row, 3} = num_cells;
        grid_data{next_row, 4} = cell_freq;
        grid_data{next_row, 5} = mask_area;
    end
    
    %% Totalgrid Data
    img_out = img;
    img_out(totalgrid_mask == 0) = 0;
    
    %% Num Cells
    cell_rois = regionprops(img_out, 'Area');
    cell_rois = cell2mat(struct2cell(cell_rois));
    cell_rois = cell_rois(cell_rois > 0);
    
    [M, num_cells] = size(cell_rois);
    cell_freq = num_cells / totalgrid_mask_area;
    
    %% Totalgrid data
    next_row = find(cellfun('isempty', totalgrid_data), 1);
    totalgrid_data{next_row, 1} = [mouse '_' img_num_str];
    totalgrid_data{next_row, 2} = 'totalgrid';
    totalgrid_data{next_row, 3} = num_cells;
    totalgrid_data{next_row, 4} = num_cells / totalgrid_mask_area;
    totalgrid_data{next_row, 5} = totalgrid_mask_area;
end

save([img_dir mouse '_griddata\C0_' mouse '_griddata'], 'grid_data', 'totalgrid_data')
end