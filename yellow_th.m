function yellow_th(mouse, img_nums_input)
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

th_base_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH\';
th_img_folder = [mouse '\'];
th_channel_num = '1';

yellow_base_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_yellow\';
yellow_img_folder = [mouse '\'];
yellow_channel_num = '4';

halfslice_lines_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH\';
halfslice_folder = [mouse '\'];

th_file_list = dir(fullfile([th_base_dir th_img_folder], ['C' th_channel_num '*.png']));
th_file_list = {th_file_list.name};
th_file_list = strrep(th_file_list, '.png', '');

yellow_file_list = dir(fullfile([yellow_base_dir yellow_img_folder], ['C' yellow_channel_num '*.png']));
yellow_file_list = {yellow_file_list.name};
yellow_file_list = strrep(yellow_file_list, '.png', '');

%% for each image
total_th = 0;
total_yellow = 0;
[M, N] = size(th_file_list);
for i = 1:1:N
    %% Check if img_num is one to be analyzed
    % example filename: C1_PZ1_1.tif
    filename_split = split(th_file_list{i}, '_');
    A=filename_split(3);
    img_num = str2num(A{1});
    
    img_num_included = ismember(img_num, rel_img_nums);
    
    %% if img_num is relevant loop
    if img_num_included
        %% Load images
        th_masks = imread([th_base_dir th_img_folder th_file_list{i} '.png']);
        yellow_masks = imread([yellow_base_dir yellow_img_folder 'C4_' mouse '_' int2str(img_num) '.png']);

        %% Load saved halfslice midline coordinates
        load([halfslice_lines_dir halfslice_folder 'C0_' mouse '_' int2str(img_num) '_halfslicelines'])

        %% TH within halfslice regions
        th_centroids = regionprops(th_masks, "Centroid");

        [M, N] = size(th_centroids);
        for roi_i = 1:1:M

            roi_c = th_centroids(roi_i).Centroid;
            % x goes right, y goes down
            roi_x = roi_c(1, 1);
            roi_y = roi_c(1, 2);

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
                    total_th = total_th + 1;
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
                    total_th = total_th + 1;
                end
            end
            
        end
        
         %% YELLOW within halfslice regions
        yellow_centroids = regionprops(yellow_masks, "Centroid");

        [M, N] = size(yellow_centroids);
        for roi_i = 1:1:M

            roi_c = yellow_centroids(roi_i).Centroid;
            % x goes right, y goes down
            roi_x = roi_c(1, 1);
            roi_y = roi_c(1, 2);

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
                    total_yellow = total_yellow + 1;
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
                    total_yellow = total_yellow + 1;
                end
            end
            
        end
    end
end

yellow_th = total_yellow / total_th;
disp(yellow_th)
save([yellow_base_dir yellow_img_folder 'C4_' mouse '_0_yellowth' yellow_th], 'yellow_th', 'total_yellow', 'total_th')
end
    