base_dir = 'E:/histology/paula/';
crop_height = 3000;
crop_width = 4000;
crop_pos = [2500 2500 crop_width crop_height];

prompt = {'Mouse:', 'Use Prior Croprect? 1 for yes:', 'Crop masks? 1 for yes:'};
default_input = {'PZ', '0', '1'};
answer = inputdlg(prompt,'Mouse Folder',[1 50], default_input);

mouse = answer{1};
use_prior_croprect = answer{2};
crop_masks = answer{3};

all_files = dir(fullfile([base_dir mouse '\'], '*.tif'));

all_file_names = {all_files(:).name};

% directory to store cropped images
if ~exist([base_dir mouse '/cropped'], 'dir')
    mkdir([base_dir mouse], 'cropped')
end

if use_prior_croprect == '1'
   load([base_dir mouse '/cropped/croprect.mat']) 
else
    croprect = {};
end

[M, N] = size(all_file_names);
tic
for i = 1:1:N
    img = imread([base_dir mouse '/' all_file_names{i}]);

    filename_split = split(all_file_names{i}, '_');
    A=filename_split(3);
    img_num = str2num(A{1}(1:end-4));
    if use_prior_croprect == '1'
        img = imcrop(img, croprect{img_num});
    else
        [O, P] = size(croprect);
        if P<img_num || isempty(croprect{img_num})
            img_adjusted = imadjust(img);
            disp(all_file_names{i})
            imshow(img_adjusted)

            h = imrect(gca, crop_pos);
            croprect{img_num} = wait(h);
        end
        img = imcrop(img, croprect{img_num});
        
    end
    [filepath,name,ext] = fileparts(all_file_names{i});
    imwrite(img, [base_dir mouse '/cropped/' name '_cropped.tif']);   % Save image 
end
toc

tic
if crop_masks == '1'
    % rect_masks
    all_maskfiles = dir(fullfile([base_dir mouse '\'], '*rect_mask.mat'));
    all_maskfile_names = {all_maskfiles(:).name};
    
    [M, N] = size(all_maskfile_names);
    for i = 1:1:N
        load([base_dir mouse '/' all_maskfile_names{i}])
        
        filename_split = split(all_maskfile_names{i}, '_');
        A=filename_split(2);
        img_num = str2num(A{1});
        
        [O, P] = size(masks);
        for j = 1:1:P
            mask = masks{j};
            mask_cropped = imcrop(mask,croprect{img_num});  
            masks_cropped{j} = mask_cropped;
        end
        masks = masks_cropped;
        [filepath,name,ext] = fileparts(all_maskfile_names{i});
        save([base_dir mouse '/cropped/' name '_cropped'], 'masks')
    end
    
    % tissuemasks
    all_maskfiles = dir(fullfile([base_dir mouse '\'], '*tissuemask.mat'));
    all_maskfile_names = {all_maskfiles(:).name};
    
    [M, N] = size(all_maskfile_names);
    for i = 1:1:N
        load([base_dir mouse '/' all_maskfile_names{i}])
        
        filename_split = split(all_maskfile_names{i}, '_');
        A=filename_split(2);
        img_num = str2num(A{1});
        
        tissue_mask_cropped = imcrop(tissue_mask,croprect{img_num});
        
        tissue_mask = tissue_mask_cropped;
        [filepath,name,ext] = fileparts(all_maskfile_names{i});
        save([base_dir mouse '/cropped/' name '_cropped'], 'tissue_mask')
    end
    
    
end
toc

save([base_dir mouse '/cropped/croprect.mat'], 'croprect')

