%% Params
base_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH\';
channel_num = '1';
line_height = 2100;

%% User input
prompt = {'Mouse:', 'Img Nums:'};
% space between matrix numbers
default_input = {'PZ', ''};
answer = inputdlg(prompt,'Halfslice Line Properties',[1 50], default_input);

mouse = answer{1};
img_nums_input = answer{2};
rel_img_nums = str2num(img_nums_input);

img_folder = [mouse '\'];
all_files = dir(fullfile([base_dir img_folder], ['C' channel_num '_*.tif']));
all_file_names = {all_files(:).name};

%% Make halfslice lines for each image
[M, N] = size(all_file_names);
for i = 1:1:N
    img = imread([base_dir img_folder all_file_names{i}]);

    %% Check if img_num is one to be analyzed
    % example filename: C1_PZ1_1.tif
    filename_split = split(all_file_names{i}, '_');
    A=filename_split(3);
    %img_num = str2num(A{1}(1:end-4)); mac 220821
    img_num = str2num(A{1});
    
    img_num_included = ismember(img_num, rel_img_nums);
    
    %% if relevant img_num, make lines
    if img_num_included

        %% Show image
        img_adjusted = imadjust(img);
        imshow(img_adjusted)
        title(all_file_names{i})

        %% Draw line
        % lhs is left half slice and rhs is right half slice
        lhs_line = imline(gca, [500 500], [500 500+line_height]);
        lhs_line_pos = wait(lhs_line);
        % must draw downwards, position = [top_pt, bottom_pt]
        rhs_line = imline(gca, [500 500], [500 500+line_height]);
        rhs_line_pos = wait(rhs_line);
        close

        %% Use line to get coordinates
        % imline position: x goes right and y goes down
        % Line?s x value itself is horizontal 0 (lhs_line_x)
        % Bottom of the line is vertical 0 (lhs_line_y)
        lhs_line_x = lhs_line_pos(2, 1);
        lhs_line_y = lhs_line_pos(2, 2);
        rhs_line_x = rhs_line_pos(2, 1);
        rhs_line_y = rhs_line_pos(2, 2);

        %% Save halfslice line coordinates
        save([base_dir img_folder 'C0_' mouse '_' int2str(img_num) '_halfslicelines'], 'lhs_line_x', 'lhs_line_y', 'rhs_line_x', 'rhs_line_y')
    end

end

