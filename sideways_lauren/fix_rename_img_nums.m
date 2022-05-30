mouse = 'PZ22';
% PZ21
% old_nums = [4 3 7 12 13 2 5 8 11 14 1 6 9 10 16 15];
% PZ22
old_nums = [4 3 5 6 7 2 11 10 9 8 1 12 13 14 16 15];

mkdir(['E:\histology\paula\' mouse '\'], 'renamed')

for i = 1:16
   movefile(['E:\histology\paula\' mouse '\C1_' mouse '_' int2str(old_nums(i)) '.tif'], ...
       ['E:\histology\paula\' mouse '\renamed\C1_' mouse '_' int2str(i) '.tif'])
   
   movefile(['E:\histology\paula\' mouse '\C2_' mouse '_' int2str(old_nums(i)) '.tif'], ...
       ['E:\histology\paula\' mouse '\renamed\C2_' mouse '_' int2str(i) '.tif'])
end