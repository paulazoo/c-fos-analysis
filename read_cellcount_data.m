base_dir = 'E:\histology\paula\';

prompt = {'Mouse:'};
default_input = {'PZ'};
answer = inputdlg(prompt,'Mouse Folder',[1 50], default_input);

mouse = answer{1};

all_files = dir(fullfile([base_dir mouse '\'], '*.mat'));

all_file_names = {all_files(:).name};

output = {'Mouse', 'Img Num', 'Region Name', 'Cell Count', 'Mask Area', 'Cell Freq'};

% step is 1 and goes up to 2 on first cfos file, because heading is row 1
step = 1;
[M, N] = size(all_file_names);
for i=1:1:N
    if endsWith(all_file_names{i}, 'cfos.mat')
        step = step + 1;
        split_file_name = split(all_file_names{i}, '_');
        
        output{step, 1} = split_file_name{1};
        output{step, 2} = split_file_name{2};
        output{step, 3} = split_file_name{3};
        
        load([base_dir mouse '\' all_file_names{i}])
        
        output{step, 4} = num_cells;
        output{step, 5} = mask_area;
        output{step, 6} = cell_freq;
    end
end

save([base_dir mouse '\cfos_data'], 'output')

disp('Finished.')