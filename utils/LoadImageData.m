% -------------------------------------------------------------------------
% function LoadImageData(imageFolder, fileFilter, descendIntoSubfolders) 
%   loads all image data into an 4D array. 
% 
% -------------------------------------------------------------------------
%   Input:
%       imageFolder     ... String. Folder where images are located
%       fileFilter      ... RegularExpression. SPM file filter 
%       descend         ... Boolean. if true, will load all matching files
%                           also in subfolders
% 
%   Output:
%       data            ... 4D Array. contains the data of images (X by Y
%                           by Z by Time)
%       volumesInfo     ... array of info on images, as return by spm_vol. 
% 
% -------------------------------------------------------------------------
function [data, volumesInfo] = LoadImageData( FOLDER_IMAGES, FILE_FILTER, DESCEND_INTO_SUBFOLDERS)

LoadSPM(); % in ../utils

if DESCEND_INTO_SUBFOLDERS
    imageFilenames = cellstr(spm_select('FPListRec',FOLDER_IMAGES,FILE_FILTER));
else
    imageFilenames = cellstr(spm_select('FPList',FOLDER_IMAGES, FILE_FILTER));
end
assert(~isempty(imageFilenames), 'CHECK_SUBJECT:FilesNotFound','No files that pass the image filter (%s) have been found.',FILE_FILTER);

% load image info
fprintf('Loading %i images...', length(imageFilenames));
volumesInfo = spm_vol(imageFilenames);
% load actual data into memory
data = spm_read_vols(cell2mat(volumesInfo));
fprintf(' done\n');
end

