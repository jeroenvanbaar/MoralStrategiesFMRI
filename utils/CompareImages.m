% Script to compare if two images are identical or not.

Data_1 = spm_read_vols(spm_vol('P:\3014018.02\3014018.02_jervbaa_150_001\40_FinalGLM\beta_0006.nii'));
Data_2 = spm_read_vols(spm_vol('C:\Users\jervbaa\Dropbox\5. PhD\0. Working folder\ClusterSimilarity\Data\allBetaMaps\p150_MultX2_run1.nii'));

% Quick way
fprintf('The two images are %.2f percent identical.\n',sum(Data_1(~isnan(Data_1)) == Data_2(~isnan(Data_2)))/length(Data_1(~isnan(Data_1)))*100);

% Visual way
figNum = 15; %arbitrary number
frameTime = .1; %in seconds
closeWhenDone = true;

figure(figNum);
for slice = 1:size(Data_1,3)
    fprintf('Slice %i\n',slice);
    subplot(1,2,1);
    slice_1 = Data_1(:,:,slice);
    imagesc(slice_1);
    subplot(1,2,2);
    slice_2 = Data_2(:,:,slice);
    imagesc(slice_2);
    vec_1 = slice_1(~isnan(slice_1));
    vec_2 = slice_2(~isnan(slice_2));
    shareTrue = sum(vec_1 == vec_2)/length(vec_1);
    suptitle(sprintf('Slice %i, %.2f percent identical',slice,shareTrue*100));
    pause(frameTime);
end
if closeWhenDone;close(figNum);end;