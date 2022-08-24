%% Params
mouse = 'PZ25';
line_height = 2100;

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';
img_folder = [mouse '\'];

halfslice_lines_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';

file_list = dir([base_dir '\' img_folder '*.png']);
file_list = {file_list.name};
file_list = strrep(file_list, '.png', '');

%% rois by dist for each image
all_x_dists = [];
all_y_dists = [];
for i = 1:1:length(file_list)
    %% Load image
    masks = imread([base_dir img_folder file_list{i} '.png']);
    
    %% Get image num
    % example filename: C1_PZ1_1.tif
    filename_split = split(all_file_names{i}, '_');
    A=filename_split(3);
    img_num = str2num(A{1}(1:end-4));
    
    %% Load saved halfslice midline coordinates
    load([halfslice_lines_dir mouse '_' int2str(img_num) '_halfslicelines'])
    
    %% Get roi centroids and loop through rois
    roi_centroids = regionprops(cp_masks, "Centroid");
    
    [M, N] = size(roi_centroids);
    for roi_i = 1:1:M
        
        roi_c = roi_centroids(roi_i).Centroid;
        % x goes right, y goes down
        roi_x = roi_c(1, 1);
        roi_y = roi_c(1, 2);
        
        %% Filter rois out of bounds
        roi_skip = 0; % default dont skip
        
        if roi_y > max(lhs_line_y+line_height, rhs_line_y+line_height)
            roi_skip = 1;
        end
        
        %% Get distances depending on which slice side centroid is on
        roi_side = '';
        if roi_skip == 1
            
        elseif roi_x < lhs_line_x
            roi_side = 'left';
            roi_x_dist = abs(roi_x - lhs_line_x);
            roi_y_dist = abs(roi_y - lhs_line_y);
            
            all_x_dists = vertcat(all_x_dists, roi_x_dist);
            all_y_dists = vertcat(all_y_dists, roi_y_dist);
            
        elseif roi_x > rhs_line_x
            roi_side = 'right';
            roi_x_dist = abs(roi_x - rhs_line_x);
            roi_y_dist = abs(roi_y - rhs_line_y);
            
            all_x_dists = vertcat(all_x_dists, roi_x_dist);
            all_y_dists = vertcat(all_y_dists, roi_y_dist);
        end
        % if in between lines, roi is ignored
    end
    
end
    