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
    apply_grid(mouse, 'paula_cFosCombined', 'cFos');
    apply_grid(mouse, 'paula_TH22', 'TH');
    cp_yellow(mouse);
    apply_grid(mouse, 'paula_yellow', 'yellow');
    selimgs = all_selimgs{m};
    get_custom_data(mouse, 'paula_cFosCombined', selimgs, groups, group_names, output_name)
    get_custom_data(mouse, 'paula_TH22', selimgs, groups, group_names, output_name)
    get_custom_data(mouse, 'paula_yellow', selimgs, groups, group_names, output_name)
end
