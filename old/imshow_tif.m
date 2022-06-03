function imshow_tif(mouse, img_num)
    channel_num = 1;
    % read in image
    img = imread(['E:\histology\paula\' mouse '\C' int2str(channel_num) '_' mouse '_' int2str(img_num) '.tif']);
%     disp(size(img))
    adjusted_img = imadjust(img);
%     disp(max(img(:)))
    
    % testing
%     min1 = prctile(adjusted_img(:), 5)
%     adjusted_img(adjusted_img < min1) = 65536;
    
    figure('Name', [mouse '_' int2str(img_num)])
    imshow(adjusted_img)
end

