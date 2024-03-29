function [all_x_dists, all_y_dists, all_z_dists] = rois_by_dist(mouse, img_nums_input, base_dir, channel_num)
%% User input
% prompt = {'Mouse:', 'Img Nums:'};
% % space between matrix numbers
% default_input = {'PZ', ''};
% answer = inputdlg(prompt,'Halfslice Line Properties',[1 50], default_input);
% 
% mouse = answer{1};
% img_nums_input = answer{2};
rel_img_nums = str2num(img_nums_input);

%% Params
line_height = 2100;
max_x_dist = 1000;

% base_dir = 'E:\histology\paula\cellpose_data_copied\220830paula_yellow2\';
img_folder = [mouse '\'];
% channel_num = '1';

halfslice_lines_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH\';
halfslice_folder = [mouse '\'];

file_list = dir(fullfile([base_dir img_folder], '*.png'));
file_list = {file_list.name};
file_list = strrep(file_list, '.png', '');

%% rois by dist for each image
all_x_dists = [];
all_y_dists = [];
all_z_dists = [];

[M, N] = size(file_list);
for i = 1:1:N
    %% Check if img_num is one to be analyzed
    % example filename: C1_PZ1_1.tif
    filename_split = split(file_list{i}, '_');
    A=filename_split(3);
    img_num = str2num(A{1});
    
    img_num_included = ismember(img_num, rel_img_nums);
    
    %% if img_num is relevant loop
    if img_num_included
        %% Load image
        cp_masks = imread([base_dir img_folder file_list{i} '.png']);

        %% Load saved halfslice midline coordinates
        load([halfslice_lines_dir halfslice_folder 'C0_' mouse '_' int2str(img_num) '_halfslicelines'])

        %% Get roi centroids and loop through rois
        roi_centroids = regionprops(cp_masks, "Centroid");

        [M, N] = size(roi_centroids);
        for roi_i = 1:1:M

            roi_c = roi_centroids(roi_i).Centroid;
            % x goes right, y goes down
            roi_x = roi_c(1, 1);
            roi_y = roi_c(1, 2);

            %% Get distances depending on which slice side centroid is on
            roi_skip = 0; % default dont skip
            if roi_x < lhs_line_x % if in between lines, roi is ignored
                %% Left Side
                % Filter rois out of bounds
                if roi_y < lhs_line_y-line_height % roi is too high
                    roi_skip = 1;
                elseif roi_y > lhs_line_y % roi is too low
                    roi_skip = 1;
                elseif roi_x < lhs_line_x - max_x_dist % roi is too far left
                    roi_skip = 1;
                end
                                
                if roi_skip == 0 % add roi
                    roi_x_dist = abs(roi_x - lhs_line_x);
                    roi_y_dist = abs(roi_y - lhs_line_y);
                    roi_z_dist = find(rel_img_nums==img_num);

                    all_x_dists = vertcat(all_x_dists, roi_x_dist);
                    all_y_dists = vertcat(all_y_dists, roi_y_dist);
                    all_z_dists = vertcat(all_z_dists, roi_z_dist);
                end

            elseif roi_x > rhs_line_x
                %% Right side
                % Filter rois out of bounds
                if roi_y < rhs_line_y-line_height % roi is too high
                    roi_skip = 1;
                elseif roi_y > rhs_line_y % roi is too low
                    roi_skip = 1;
                elseif roi_x < rhs_line_x + max_x_dist % roi is too far right
                    roi_skip = 1;
                end
                
                if roi_skip == 0 % add roi
                    roi_x_dist = abs(roi_x - rhs_line_x);
                    roi_y_dist = abs(roi_y - rhs_line_y);
                    roi_z_dist = find(rel_img_nums==img_num);

                    all_x_dists = vertcat(all_x_dists, roi_x_dist);
                    all_y_dists = vertcat(all_y_dists, roi_y_dist);
                    all_z_dists = vertcat(all_z_dists, roi_z_dist);
                end
            end
            
        end
    end
end

save([base_dir img_folder 'C' channel_num '_' mouse '_0_alldists'], 'all_x_dists', 'all_y_dists', 'all_z_dists')
end
    
