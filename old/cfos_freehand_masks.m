user_done = 0;

while user_done == 0

    img_done = 0;

    prompt = {'Mouse:','Image Number:', 'Region Name:'};
    default_input = {'PZ', '1', ''};
    answer = inputdlg(prompt,'Region Mask Properties',[1 50], default_input);

    mouse = answer{1};
    img_num = str2num(answer{2});
    region_name = answer{3};

    % read in image
    th_img = imread(['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(img_num) '.tif']);

    % create mask for analysis region
    adjusted_th_img = imadjust(th_img);
    figure('Name', [mouse '_' int2str(img_num)])
    imshow(adjusted_th_img)

    while img_done == 0
        hFH = imfreehand();
        % Create a binary image ("mask") from the ROI object
        mask = hFH.createMask();

        save(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_' region_name '_mask'], 'mask')

        disp('Region mask saved!')

        prompt = {'Create another mask? Enter 1:', 'New region name:'};
        answer = inputdlg(prompt,'More Regions?',[1 50]);
        if answer{1} ~= '1'
            img_done = 1;
        else
            region_name = answer{2};
        end
    end
    
    prompt = {'Do another mouse image? Enter 1:'};
    answer = inputdlg(prompt,'New mouse image?',[1 50]);
    if answer{1} ~= '1'
        user_done = 1;
    end

end