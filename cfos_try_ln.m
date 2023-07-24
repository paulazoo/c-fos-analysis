function cfos_try_ln(mouse)
%% Params
% mouse = 'PZ39';
% start_file = 13;
% end_file = 16;

base_dir = 'E:\histology\paula\cellpose_data_copied\220830paula_CFOS\';
img_folder = [mouse '\'];
cfos_channel_num = '2';

file_list = dir([base_dir img_folder 'C' cfos_channel_num '_*.tif']);
file_list = {file_list.name};
file_list = strrep(file_list, '.tif', '');

%% Peak finding params
peak_diameter = 12;
diameter_multiplier = 300;
medsizes = [3, 3];

%% Make New Folders
output_folder = [mouse '_ln'];
mkdir(base_dir, output_folder)

for i = 1:1:length(file_list)
    %% Load c-Fos image
    cfos_img = imread([base_dir img_folder file_list{i} '.tif']);
    
    %% Img num
    % example filename: C1_PZ1_1.tif
    filename_split = split(file_list{i}, '_');
    A=filename_split(3);
    img_num = str2num(A{1});
    
    %% Get rid of noise
    cfos_img2 = cfos_img;
    
    cfos_img2 = medfilt2(cfos_img2, medsizes, 'symmetric'); % 2D Median filter
    
     %% Local Normalize
    gausssizes = [peak_diameter, peak_diameter*diameter_multiplier];

    % gaussian normalize
    f_prime = single(cfos_img2)-single(imgaussfilt(single(cfos_img2),gausssizes(1)));
    ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
    ln_img(isnan(ln_img)) = 0;
    
    %% gaussian smooth image
%     filt = (fspecial('gaussian', peak_diameter, 1)); %if needed modify the filter according to the expected peaks sizes
%     ln_img2=conv2(single(ln_img),filt,'same');
    
    %% rescale
    ln_img2 = rescale(ln_img, 0, max(cfos_img(:)));
    ln_img2 = uint16(ln_img2);
    
    %% Write output image
    imwrite(ln_img2, [base_dir mouse '_ln\' file_list{i} '_ln.tif'], 'tiff')

end
end
