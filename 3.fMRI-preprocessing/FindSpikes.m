clear all;clc;
load('subNums.mat');

for i = oldsubs
    nrnii = size(ls(sprintf('../3014018.02_jervbaa_%i_001/data_quality_checks/*.nii',i)),1);
    fprintf('Subject %i, %i spike niftis\n',i,nrnii);
end

for i = newsubs
    nrnii = size(ls(sprintf('../3014018.02_jervbaa_%i_001/data_quality_checks/*.nii',i)),1);
    fprintf('Subject %i, %i spike niftis\n',i,nrnii);
end

% Add spike at sub 190 run 2 vol 221 to rp
sub = 190;
run = 2;
vol = 221;
filename = ls(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/rp*',sub,run));
% copyfile(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename),...
%     sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/old_rp_without_spike.txt',sub,run));
rp = dlmread(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename));
rp(221,7) = 1;
dlmwrite(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename),...
    rp,'\t');