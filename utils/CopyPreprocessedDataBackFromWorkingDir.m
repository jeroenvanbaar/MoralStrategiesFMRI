function CopyPreprocessedDataBackFromWorkingDir(DIR_WORKING_STRUCTURAL, ...
    DIR_STRUCTURAL,...
    DIR_WORKING_COMBINED, ...
    DIR_COMBINED, ...
    KEEP_INTERMEDIARY_FILES)
% copy files back from working directory to relevant directories on m-drive
% 
% This includes:
%   1) all structural data (e.g. segmentation maps)
%   2) all desired preprocessed files
%   
%  the flag KEEP_INTERMEDIARY_FILES determines whether all the intermediary
%  steps for the functional images are to be also copied back or not. If
%  no, only the final, 'swacrf*.nii' are copied back into the respective
%  folder(s); if yes, all the intermediate steps are also copied (also the
%  i.e. 'acrf*.nii', 'wacrf*.nii' files).

% copy first all content of structural data.
%--------------------------------------------------------------------------
unixCommand = sprintf('cp -r %s/* %s/.', DIR_WORKING_STRUCTURAL, DIR_STRUCTURAL);
unix(unixCommand);

% copy all desired functional files back to m-drive
%--------------------------------------------------------------------------
% copy only 'swacrf' files, while maintaining the folder structure
% this procedure is based on:
% http://stackoverflow.com/questions/8798153/recursively-move-files-of-certain-type-and-keep-their-directory-structure
oldFolder = pwd;
cd(DIR_WORKING_COMBINED);
unixCommand = sprintf('find . -name ''swacrf*.nii'' -print | cpio -pdumB --quiet %s', DIR_COMBINED);
unix(unixCommand);

if KEEP_INTERMEDIARY_FILES
    % copy normalized images 
    unixCommand = sprintf('find . -name ''wacrf*.nii'' -print | cpio -pdumB --quiet %s', DIR_COMBINED);
    unix(unixCommand);
    
    % copy slice-timing corrected
    unixCommand = sprintf('find . -name ''acrf*.nii'' -print | cpio -pdumB --quiet %s', DIR_COMBINED);
    unix(unixCommand);
end
cd(oldFolder);

fprintf('done copying preprocessed images to m-drive')

end