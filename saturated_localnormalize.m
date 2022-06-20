
mouse = 'PZ25';

base_dir = 'E:\histology\paula\cellpose_data_copied\paula_TH\';
cp_diameter = 23;
img_folder = [mouse '\'];
ln_folder = [mouse '_ln\'];

file_list = dir([base_dir img_folder '*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');


%% Make ln folder
mkdir([base_dir ln_folder])

for i = 1:1:length(file_list)
    %% Load image
    th_img = imread([base_dir img_folder file_list{i} '.tif']);
    
    %% Local Normalize for visualizing saturated regions CP Params
    gausssizes = [cp_diameter, cp_diameter*0.25];
    medsizes = [2, 2];

    %% Local Normalize

    % 2D filter
    th_img = medfilt2(th_img, medsizes, 'symmetric');

    % gaussian normalize
    f_prime = single(th_img)-single(imgaussfilt(single(th_img),gausssizes(1)));
    ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
    ln_img(isnan(ln_img)) = 0;

    % rescale
    ln_img2 = rescale(ln_img, 0, max(th_img(:)));
    ln_img2 = uint16(ln_img2);

    % write output
    imwrite(ln_img2, [base_dir ln_folder file_list{i} '_ln.tif'], 'tif')

end
