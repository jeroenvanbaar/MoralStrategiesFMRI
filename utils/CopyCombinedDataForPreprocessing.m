function locationCombined = CopyCombinedDataForPreprocessing(DIR_COMBINED,DIR_WORKING)
% 
% Copy combined nifti images needed for preprocessing to working direcory
% 
% We want to copy only the relevant files to the working directory. These
% include only 'crf' prefixed files and the mean image. Importantly, we
% want to keep any folder structure that might be present in the
% 'data_combined' folder. For example, if runs are sorted into 'run1',
% 'run2', etc. subfolders, we want to keep those. if no subfolders are
% present, then we just copy.
% 
% This should enable to create the preprocessing job on referencing the
% m-drive in SPM's batch editor, but run it also from the working
% directory.
% 

SUB_FOLDER = 'combined'; % we're going to create a subfolder in working dir for keeping the combined files

% create subfolder where combined images will be stored
locationCombined = fullfile(DIR_WORKING, SUB_FOLDER);
[~, ~, ~]=mkdir(locationCombined);

oldFolder = pwd;
cd(DIR_COMBINED);

% copy only 'crf' files, while maintaining the folder structure
% this procedure is based on:
% http://stackoverflow.com/questions/8798153/recursively-move-files-of-certain-type-and-keep-their-directory-structure
unixCommand = sprintf('find . -name ''crf*.nii'' -print | cpio -pdumB --quiet %s', locationCombined);
unix(unixCommand);

% use same as above for mean image
unixCommand = sprintf('find . -name ''meanf*.nii'' -print | cpio -pdumB --quiet %s', locationCombined);
unix(unixCommand);

cd(oldFolder);

end