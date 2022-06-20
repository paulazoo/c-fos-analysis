

%% Congregate Data
% mice = ["PZ5", "PZ6", "PZ7", "PZ8", "PZ9", "PZ19", "PZ21", "PZ22", "PZ23", "PZ24", "PZ25"];
% mice = ["PZ19", "PZ21", "PZ22", "PZ23", "PZ24", "PZ25"];
% mice = ["PZ5", "PZ6", "PZ7", "PZ8", "PZ9"];
% mice = ["PZ5", "PZ8", "PZ19", "PZ21", "PZ24"];
mice = ["PZ6", "PZ7", "PZ9", "PZ22", "PZ23", "PZ25"];

alldata = zeros(length(mice), 1);
all_sects = zeros(length(mice), 6);
all_sectsf = zeros(length(mice), 6);

for m = 1:1:length(mice)
    mouse = convertStringsToChars(mice(m));
    load(['E:\histology\paula\cellpose_data_copied\paula_yellow\' mouse '\' mouse '_customdata6s.mat'])
    alldata(m, 1) = customtotal_data{1, 3};
    
    all_sects(m, 1) = customsect_data{1, 3};
    all_sects(m, 2) = customsect_data{2, 3};
    all_sects(m, 3) = customsect_data{3, 3};
    all_sects(m, 4) = customsect_data{4, 3};
    all_sects(m, 5) = customsect_data{5, 3};
    all_sects(m, 6) = customsect_data{6, 3};
    
    all_sectsf(m, 1) = customsect_data{1, 4};
    all_sectsf(m, 2) = customsect_data{2, 4};
    all_sectsf(m, 3) = customsect_data{3, 4};
    all_sectsf(m, 4) = customsect_data{4, 4};
    all_sectsf(m, 5) = customsect_data{5, 4};
    all_sectsf(m, 6) = customsect_data{6, 4};
end

%%
% mice = ["PZ5", "PZ6", "PZ7", "PZ8", "PZ9", "PZ19", "PZ21", "PZ22", "PZ23", "PZ24", "PZ25"];
% mice = ["PZ5", "PZ8", "PZ19", "PZ21", "PZ24"];
mice = ["PZ6", "PZ7", "PZ9", "PZ22", "PZ23", "PZ25"];

for m = 1:1:length(mice)
    mouse = convertStringsToChars(mice(m));
    load(['E:\histology\paula\cellpose_data_copied\paula_TH22\' mouse '\' mouse '_customdata6s.mat'])
    
    num_cells = customsect_data{1, 3} + customsect_data{2, 3} + customsect_data{3, 3};
    mask_area = customsect_data{1, 5} + customsect_data{2, 5} + customsect_data{3, 5};
    cell_freq = num_cells / mask_area;
end

%% Batch Data
mice = ["PZ5", "PZ6", "PZ7", "PZ8", "PZ9", "PZ19", "PZ21", "PZ22", "PZ23", "PZ24", "PZ25"];

groups = {{'ls1', 'rs1'}; {'ls2', 'rs2'}; {'ls3', 'rs3'}; {'ls4', 'rs4'}; {'ls5', 'rs5'}; {'ls6', 'rs6'}};
group_names = ["s1", "s2", "s3", "s4", "s5", "s6"];
output_name = '6s';

%               PZ5            PZ6            PZ7           PZ8 
%               PZ9            PZ19           PZ21          PZ22
%               PZ23           PZ24           PZ25
all_selimgs = {[6, 7, 8, 9], [6, 7, 8, 9], [6, 7, 8, 9], [6, 7, 8, 9], ...
               [6, 7, 8, 9], [6, 7, 8, 9], [5, 6, 7, 8], [7, 8, 9, 10], ...
               [5, 6, 7, 8], [5, 6, 7, 8], [5, 6, 7, 8]};

for m = 1:1:length(mice)
    mouse = convertStringsToChars(mice(m));
     selimgs = all_selimgs{m};
%     apply_grid(mouse, 'paula_cFosCombined', 'cFos');
%    apply_grid(mouse, 'paula_TH22', 'TH');
%     get_custom_data(mouse, 'paula_TH22', selimgs, groups, group_names, output_name)
     find_cfos_peaks(mouse, 'paula_yellowPeak90');
     apply_grid(mouse, 'paula_yellowPeak90', 'yellow');
     get_custom_data(mouse, 'paula_yellowPeak90', selimgs, groups, group_names, output_name)
end

%% Rough TH Count
