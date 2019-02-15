function locationStructural = CopyStructuralDataForPreprocessing(DIR_STRUCTURAL,DIR_WORKING)
% 
% Copy structural nifti image needed for preprocessing to working direcory
% 
% This should enable to create the preprocessing job on referencing the
% m-drive in SPM's batch editor, but run it also from the working
% directory.
% 

SUB_FOLDER = 'structural';

locationStructural = fullfile(DIR_WORKING, SUB_FOLDER);
[~, ~, ~]=mkdir(locationStructural); % assert folder exists

% Copy the whole content of DIR_STRUCTURAL. 
% We're assuming only a single 's*.nii' file is there.
unixCommand = sprintf('cp -r %s/* %s/.', DIR_STRUCTURAL, locationStructural);
unix(unixCommand);

end