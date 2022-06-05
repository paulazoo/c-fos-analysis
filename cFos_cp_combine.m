base_dir = 'F:\analysis\paula\cellpose_data\';
output_dir = 'paula_cFosCombined';

batch_small = 'paula_cFos16';
batch_big = 'paula_cFos22';

mice = {'PZ5', 'PZ6', 'PZ7', 'PZ8'};

mkdir(base_dir, output_dir)

[M, N] = size(mice);
for m = 1:1:N
    mouse = char(mice(m));
    mkdir([base_dir output_dir], mouse)
    for img_num = 1:1:16
        mask_small = imread([base_dir batch_small '\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
        mask_big = imread([base_dir batch_big '\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped_cp_masks.png']);
        mask_combined = mask_small + mask_big;
        imwrite(mask_combined, [base_dir output_dir '\' mouse '\C2_' mouse '_' int2str(img_num) '_cropped_cp_masks.png'])
    end
end