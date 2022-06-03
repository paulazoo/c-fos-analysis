prompt = {'Mouse:', 'Cropped? 1 = yes:'};
default_input = {'PZ25', '1'};
answer = inputdlg(prompt,'Grid Properties',[1 50], default_input);

mouse = answer{1};
cropped = answer{2};

for i = 1:1:16
    img_num = i;

    height = 2100;
    avpv_width = 400;
    section_height = 700;
    mpoa_width = 600;

    imshow_croptif(mouse, img_num);
    h1 = imline(gca, [500 500], [500 500+height]);
    pos_left = wait(h1);
    % must draw downwards, position = [top_pt, bottom_pt]
    h2 = imline(gca, pos_left);
    pos_right = wait(h2);

    pl_topright_temp = pos_left(1,:);
    pl_bottomright = pos_left(2,:);
    pr_topleft_temp = pos_right(1,:);
    pr_bottomleft = pos_right(2,:);

    pl_u=(pl_topright_temp-pl_bottomright)./norm(pl_topright_temp-pl_bottomright);
    pr_u=(pr_topleft_temp-pr_bottomleft)./norm(pr_topleft_temp-pr_bottomleft);

    pl_u_perp = [pl_u(2) -1*pl_u(1)];
    pr_u_perp = [-1*pr_u(2) pr_u(1)];

    pl_topright = pl_bottomright + (height.*pl_u);
    pr_topleft = pr_bottomleft + (height.*pr_u);

    pl_bottomleft = pl_bottomright + (avpv_width.*pl_u_perp);
    pr_bottomright = pr_bottomleft + (avpv_width.*pr_u_perp);

    pl_topleft = pl_bottomleft + (height.*pl_u);
    pr_topright = pr_bottomright + (height.*pr_u);


    %length = sqrt( ((pos_left(2,2)-pos_left(1,2))^2) + ((pos_left(2,1)-pos_left(1,1))^2) );

    % vertically split into 3 equal sections (2100 total, 700 each section)
    % horizontally split into first 400 for avpv, rest is mpoa

    lavpv1_pos = [pl_bottomleft; pl_bottomright; pl_bottomright + (section_height.*pl_u); pl_bottomleft + (section_height.*pl_u)];
    ravpv1_pos = [pr_bottomleft; pr_bottomright; pr_bottomright + (section_height.*pr_u); pr_bottomleft + (section_height.*pr_u)];
    polycell{1} = impoly(gca, lavpv1_pos);
    polycell{2} = impoly(gca, ravpv1_pos);
    polycell{3} = impoly(gca, lavpv1_pos + (section_height.*pl_u));
    polycell{4} = impoly(gca, ravpv1_pos + (section_height.*pr_u));
    polycell{5} = impoly(gca, lavpv1_pos + (2*section_height.*pl_u));
    polycell{6} = impoly(gca, ravpv1_pos + (2*section_height.*pr_u));

    lmpoa1_pos = lavpv1_pos + (avpv_width.*pl_u_perp);
    rmpoa1_pos = ravpv1_pos + (avpv_width.*pr_u_perp);
    lmpoa1_pos(1, :) = lmpoa1_pos(1, :) + ((mpoa_width - avpv_width).*pl_u_perp);
    lmpoa1_pos(4, :) = lmpoa1_pos(4, :) + ((mpoa_width - avpv_width).*pl_u_perp);
    rmpoa1_pos(2, :) = rmpoa1_pos(2, :) + ((mpoa_width - avpv_width).*pr_u_perp);
    rmpoa1_pos(3, :) = rmpoa1_pos(3, :) + ((mpoa_width - avpv_width).*pr_u_perp);
    polycell{7} = impoly(gca, lmpoa1_pos);
    polycell{8} = impoly(gca, rmpoa1_pos);
    polycell{9} = impoly(gca, lmpoa1_pos + (section_height.*pl_u));
    polycell{10} = impoly(gca, rmpoa1_pos + (section_height.*pr_u));
    polycell{11} = impoly(gca, lmpoa1_pos + (2*section_height.*pl_u));
    polycell{12} = impoly(gca, rmpoa1_pos + (2*section_height.*pr_u));

    names_key = {'ls1', 'rs1', 'ls2', 'rs2', 'ls3', 'rs3', 'ls4', 'rs4', 'ls5', 'rs5', 'ls6', 'rs6'};

    % actual mask creation
    [M, N] = size(polycell);
    masks = {};
    for i=1:1:N
        masks{i} = createMask(polycell{i});
    end

    save(['E:\histology\paula\' mouse '\' mouse '_' int2str(img_num) '_grid'], 'masks', 'names_key')

end

