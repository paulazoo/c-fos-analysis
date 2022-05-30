prompt = {'Mouse:','Image Number:', 'Cropped? 1 = yes:'};
default_input = {'PZ', '1', '1'};
answer = inputdlg(prompt,'Analysis Properties',[1 50], default_input);

mouse = answer{1};
img_num = str2num(answer{2});
cropped = answer{3};

for i = 1:1:16
    img_num = i;

    if cropped == '1'
        th_img = imread(['E:\histology\paula\' mouse '\cropped\C1_' mouse '_' int2str(img_num) '_cropped.tif']);
    else
        % read in image
        % cfos_img = imread(['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(img_num) '.tif']);
        th_img = imread(['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(img_num) '.tif']);
    end
    % adjusted_cfos = imadjust(cfos_img);
    adjusted_th = imadjust(th_img);

    figure('Name', ['Draw tissue for ' mouse '_' int2str(img_num)])
    imshow(adjusted_th);
    hFH = imfreehand();
    tissue_mask = hFH.createMask();
    hole_done = 0;
    while hole_done == 0
        prompt = {'Edit more mask holes? 1 for yes:'};
        answer = inputdlg(prompt,'Analysis Properties',[1 50]);
        if answer{1} == '1'
            hFH = imfreehand();
            hole_mask = hFH.createMask();
            tissue_mask(hole_mask == 1) = 0;
        else
            hole_done = 1;
        end
    end
    % imshow(tissue_mask)

    if cropped == '1'
        save(['E:\histology\paula\' mouse '\cropped\' mouse '_' int2str(img_num) '_tissuemask_cropped.mat'], 'tissue_mask')
    else
        save(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_tissuemask.mat'], 'tissue_mask')
    end

end