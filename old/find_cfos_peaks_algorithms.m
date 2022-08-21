 %% Local Normalize
    tic
    cfos_img2 = cfos_img;
    cfos_img2(tissue_mask == 0) = 0;

    gausssizes = [cfos_diameter, cfos_diameter*diameter_multiplier];
    medsizes = [2, 2];
    % 2D filter
    cfos_img2 = medfilt2(cfos_img2, medsizes, 'symmetric');

    % gaussian normalize
    f_prime = single(cfos_img2)-single(imgaussfilt(single(cfos_img2),gausssizes(1)));
    ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
    ln_img(isnan(ln_img)) = 0;

%     thres = (max([min(max(cfos_img2,[],1))  min(max(cfos_img2,[],2))]));
    toc
    
    %% Thresh and smooth and thresh
    tic
    ln_thresh  = prctile(ln_img(:), ln_thresh_percentile);

    peaks_img2=ln_img.*(ln_img>ln_thresh);
    % smooth image
    filt = (fspecial('gaussian', cfos_diameter, 1)); %if needed modify the filter according to the expected peaks sizes
    peaks_img2=conv2(single(peaks_img2),filt,'same') ;
    % Apply again threshold (and change if needed according to SNR)
    peaks_img2=peaks_img2.*(peaks_img2>0.9*(ln_img>ln_thresh));

    toc
    
    %% Local Maxima
    tic
    % d will be noisy on the edges, and also local maxima looks
    % for nearest neighbors so edge must be at least 1. We'll skip 'edge' pixels.
    edg = 3;
    sd=size(peaks_img2);
    [x, y]=find(peaks_img2(edg:sd(1)-edg,edg:sd(2)-edg));

    % initialize outputs
    cent=[];%
    cent_map=zeros(sd);

    x=x+edg-1;
    y=y+edg-1;
    for j=1:length(y)
        if (peaks_img2(x(j),y(j))>peaks_img2(x(j)-1,y(j)-1 )) &&...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-1,y(j))) &&...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-1,y(j)+1)) &&...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j),y(j)-1)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j),y(j)+1)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+1,y(j)-1)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+1,y(j))) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+1,y(j)+1)) && ...
                ...
                ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-2,y(j))) &&...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-2,y(j)+1)) &&...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-2,y(j)-1)) &&...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+2,y(j))) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+2,y(j)+1)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+2,y(j)-1)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j),y(j)-2)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+1,y(j)-2)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-1,y(j)-2)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j),y(j)+2)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)+1,y(j)+2)) && ...
                (peaks_img2(x(j),y(j))>peaks_img2(x(j)-1,y(j)+2))

            cent = [cent ;  y(j) ; x(j)];
            cent_map(x(j),y(j))=cent_map(x(j),y(j))+1; % if a binary matrix output is desired

        end
    end

    toc
    
    
    
    %% c-Fos
    cfos_img2 = cfos_img;
    cfos_img2(tissue_mask == 0) = 0;

    gausssizes = [cfos_diameter, 64];
    medsizes = [2, 2];
    % 2D filter
    cfos_img2 = medfilt2(cfos_img2, medsizes, 'symmetric');

    % gaussian normalize
    f_prime = single(cfos_img2)-single(imgaussfilt(single(cfos_img2),gausssizes(1)));
    ln_img = f_prime./(imgaussfilt(f_prime.^2,gausssizes(2)).^(1/2));
    ln_img(isnan(ln_img)) = 0;

    % ln_thresh = (max([min(max(ln_img2,[],1))  min(max(ln_img2,[],2))]));
    ln_thresh  = prctile(ln_img(:), 80);
    % disp(ln_thresh)
    ln_img2 = ln_img;
    ln_img2(ln_img2 < ln_thresh) = 0;
    ln_img2 = logical(ln_img2);

    thres = (max([min(max(cfos_img2,[],1))  min(max(cfos_img2,[],2))]));
    filt = (fspecial('gaussian', 20,1)); %if needed modify the filter according to the expected peaks sizes

%     cfos_img2 = medfilt2(cfos_img2,[2,2]);
    cfos_img2=cfos_img2.*uint16(cfos_img2>thres);
    % smooth image
    cfos_img2=conv2(single(cfos_img2),filt,'same') ;
    % Apply again threshold (and change if needed according to SNR)
    cfos_img2=cfos_img2.*(cfos_img2>0.9*thres);
