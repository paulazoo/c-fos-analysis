function get_custom_data(mouse, selimgs)
%% Params
% mouse = 'PZ8';

griddata_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH23\';
griddata_folder = [mouse '_griddata\'];

file_list = dir([griddata_dir griddata_folder '*.mat']);
file_list = {file_list.name};
file_list = strrep(file_list, '.mat', '');

%% Selection Params
% selimgs = [6, 7, 8, 9];
% groups = {{'ls1', 'rs1'}; {'ls2', 'rs2'}; {'ls3', 'rs3'}; {'ls4', 'rs4'}; {'ls5', 'rs5'}; {'ls6', 'rs6'};};
% group_names = ["s1", "s2", "s3", "s4", "s5", "s6"];
% output_name = '6s';

% selimgs = [6, 7, 8, 10];
groups = {{'ls1', 'rs1', 'ls2', 'rs2', 'ls4', 'rs4', 'ls5', 'rs5'};};
group_names = ["ventral"];
output_name = 'AVPVventral';

customdata_folder = [mouse '_customdata' output_name '\'];

%% Make customdata folder
mkdir(griddata_dir, customdata_folder)

%% Load griddata
load([griddata_dir griddata_folder '\' file_list{1}])

%% Going through griddata
[M, N] = size(groups);
customsect_data = cell(M, 5);
for group_i = 1:1:M
    group = groups{group_i};
    [O, P] = size(group);

    group_num_cells = 0;
    group_mask_area = 0;
    for sect_i = 1:1:P

        for img_i = 1:1:length(selimgs)
            img_num = selimgs(img_i);
            img_data = grid_data(find( strcmp([{grid_data{:,1}}], [mouse '_' int2str(img_num)]) ),:);

            section_name = group{sect_i};
            section_data = img_data(find( strcmp([{img_data{:,2}}], section_name) ),:);

            group_num_cells = group_num_cells + section_data{1, 3};
            group_mask_area = group_mask_area + section_data{1, 5};
        end
    end
    customsect_data{group_i, 1} = [mouse '_' group_names(group_i)];
    customsect_data{group_i, 2} = group_names(group_i);
    customsect_data{group_i, 3} = group_num_cells;
    customsect_data{group_i, 4} = group_num_cells / group_mask_area;
    customsect_data{group_i, 5} = group_mask_area;
end

%% Save Customdata Result
save([griddata_dir customdata_folder 'C0_' mouse '_customdata' output_name], 'customsect_data')
