%% sat ln
% 
% saturated_localnormalize('PZ29');
% saturated_localnormalize('PZ30');
% saturated_localnormalize('PZ31');
% 
% saturated_localnormalize('PZ39');
% saturated_localnormalize('PZ43');
% saturated_localnormalize('PZ44');
% saturated_localnormalize('PZ45');
% saturated_localnormalize('PZ46');
% saturated_localnormalize('PZ47');
% saturated_localnormalize('PZ48');
% 
% saturated_localnormalize('PZ54');
% saturated_localnormalize('PZ55');
% saturated_localnormalize('PZ56');
% saturated_localnormalize('PZ57');

%% TH cfos

% th_cp_filters('PZ29')
% th_cp_filters('PZ30')
% th_cp_filters('PZ31')
% 
% th_cp_filters('PZ39')
% th_cp_filters('PZ43')
% th_cp_filters('PZ44')
% th_cp_filters('PZ45')
% th_cp_filters('PZ46')
% th_cp_filters('PZ47')
% th_cp_filters('PZ48')
% 
% th_cp_filters('PZ54')
% th_cp_filters('PZ55')
% th_cp_filters('PZ56')
% th_cp_filters('PZ57')

% find_cfos_peaks('PZ39')
% find_cfos_peaks('PZ43')
% find_cfos_peaks('PZ44')
% find_cfos_peaks('PZ45')
% find_cfos_peaks('PZ46')
% find_cfos_peaks('PZ47')
% find_cfos_peaks('PZ48')


%% cp yellow dists
th_base_dir = 'E:\histology\paula\cellpose_data_copied\220823paula_TH\';
cfos_base_dir = 'E:\histology\paula\cellpose_data_copied\220923paula_yellow7\';
% cp_yellow('PZ43')
%out of 8 slices, pick ending 6
[x1 y1 z1] = rois_by_dist('PZ43', '5 6 7 8 9 10', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ43', '5 6 7 8 9 10', cfos_base_dir, '4');
disp(length(x2)/length(x1))
% cp_yellow('PZ44')
[x1 y1 z1] = rois_by_dist('PZ44', '4 5 6 7 8 9', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ44', '4 5 6 7 8 9', cfos_base_dir, '4');
disp(length(x2)/length(x1))
% cp_yellow('PZ45')
[x1 y1 z1] = rois_by_dist('PZ45', '7 8 9 10 11 12', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ45', '7 8 9 10 11 12', cfos_base_dir, '4');
disp(length(x2)/length(x1))
% cp_yellow('PZ39')
[x1 y1 z1] = rois_by_dist('PZ39', '5 6 7 8 9 10', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ39', '5 6 7 8 9 10', cfos_base_dir, '4');
disp(length(x2)/length(x1))
% cp_yellow('PZ46')
[x1 y1 z1] = rois_by_dist('PZ46', '7 8 9 10 11 12', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ46', '7 8 9 10 11 12', cfos_base_dir, '4');
disp(length(x2)/length(x1))
% cp_yellow('PZ47')
[x1 y1 z1] = rois_by_dist('PZ47', '7 8 9 10 11 12', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ47', '7 8 9 10 11 12', cfos_base_dir, '4');
disp(length(x2)/length(x1))
% cp_yellow('PZ48')
[x1 y1 z1] = rois_by_dist('PZ48', '5 6 7 8 9 10', th_base_dir, '1');
[x2 y2 z2] = rois_by_dist('PZ48', '5 6 7 8 9 10', cfos_base_dir, '4');
disp(length(x2)/length(x1))

%% TH dists
% close('all')
% allx = [];
% ally = [];
% allz = [];
% [x y z] = rois_by_dist('PZ43', '3 4 5 6 7 8 9 10');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ44', '2 3 4 5 6 7 8 9');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ45', '5 6 7 8 9 10 11 12');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% disp(length(allx) / 3) % 775.3333
% figure
% histogram(ally, 3)
% 
% allx = [];
% ally = [];
% allz = [];
% [x y z] = rois_by_dist('PZ39', '3 4 5 6 7 8 9 10');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ46', '5 6 7 8 9 10 11 12');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ47', '5 6 7 8 9 10 11 12');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ48', '3 4 5 6 7 8 9 10');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% disp(length(allx) / 4) % 752.2500
% figure
% histogram(ally, 3)
% 
% allx = [];
% ally = [];
% allz = [];
% [x y z] = rois_by_dist('PZ54', '2 3 4 5 6 7 8 9');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ55', '4 5 6 7 8 9 10 11');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ56', '3 4 5 6 7 8 9 10');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% [x y z] = rois_by_dist('PZ57', '3 4 5 6 7 8 9 10');
% allx = vertcat(allx, x);
% ally = vertcat(ally, y);
% allz = vertcat(allz, z);
% disp(length(allx) / 4)
% figure
% histogram(ally, 3)



%%
cfos_try_ln('PZ39')
cfos_try_ln('PZ43')
cfos_try_ln('PZ44')
cfos_try_ln('PZ45')
cfos_try_ln('PZ46')
cfos_try_ln('PZ47')
cfos_try_ln('PZ48')
