function get_custom_data(mouse, batch, selimgs, groups, group_names, output_name)
%     selimgs = [6, 7, 8, 9];
%     groups = {{'ls1', 'rs1'}; {'ls2', 'rs2'}; {'ls3', 'rs3'}; {'ls4', 'rs4'}; {'ls5', 'rs5'}; {'ls6', 'rs6'}};
%     group_names = ["s1", "s2", "s3", "s4", "s5", "s6"];
%     output_name = '6s';

    %%
    base_dir = 'E:\histology\paula\cellpose_data_copied\';

    load([base_dir batch '\' mouse '\' mouse '_griddata'])

    [M, N] = size(groups);
    customsect_data = cell(M, 5);
    for j = 1:1:M
        group = groups{j};
        [O, P] = size(group);

        group_num_cells = 0;
        group_mask_area = 0;
        for k = 1:1:O

            for i = 1:1:length(selimgs)
                img_num = selimgs(i);
                img_data = grid_data(find( strcmp([{grid_data{:,1}}], [mouse '_' int2str(img_num)]) ),:);

                section_name = group{k};
                section_data = img_data(find( strcmp([{img_data{:,2}}], section_name) ),:);

                group_num_cells = group_num_cells + section_data{1, 3};
                group_mask_area = group_mask_area + section_data{1, 5};
            end
        end
        customsect_data{j, 1} = [mouse '_' int2str(img_num)];
        customsect_data{j, 2} = group_names(j);
        customsect_data{j, 3} = group_num_cells;
        customsect_data{j, 4} = group_num_cells / group_mask_area;
        customsect_data{j, 5} = group_mask_area;
    end

    customtotal_data = cell(1, 5);
    customtotal_data{1, 1} = [mouse '_selimgs'];
    customtotal_data{1, 2} = 'totalgrid';
    customtotal_data{1, 3} = 0;
    customtotal_data{1, 5} = 0;
    for i = 1:1:length(selimgs)
        img_num = selimgs(i);
        img_data = totalgrid_data(find( strcmp([{totalgrid_data{:,1}}], [mouse '_' int2str(img_num)]) ),:);
        customtotal_data{1, 3} = customtotal_data{1, 3} + img_data{1, 3};
        customtotal_data{1, 5} = customtotal_data{1, 5} + img_data{1, 5};
    end
    customtotal_data{1, 4} = customtotal_data{1, 3} / customtotal_data{1, 5};

    save([base_dir batch '\' mouse '\' mouse '_customdata' output_name], 'customsect_data', 'customtotal_data')
end