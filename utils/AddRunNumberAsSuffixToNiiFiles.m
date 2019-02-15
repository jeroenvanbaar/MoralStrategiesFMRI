function AddRunNumberAsSuffixToNiiFiles(folder)
% Function AddRunNumberAsSuffixToNiiFiles(folder)
% 
% This function looks for 'run1', 'run2', etc. folders inside the 'folder'
% provided as input, and adds to all '.nii' files the string 'run1' as a
% suffix, just before the file extension
% 
% This is a simple wrapper function for the bash-script 'add_suffix_nii.sh'
% expected to be inside the utils folder
% 

% figure out the location of the 'utils' folder - also where this function
% is expected to be
fullpathFilename = mfilename('fullpath');
[utilsPath, ~, ~] = fileparts(fullpathFilename);

oldFolder = pwd;
cd(folder);

% use bash script to append run number to .nii files
unixCommand = sprintf('find -type d -name ''run*'' | xargs %s/add_suffix_nii.sh', utilsPath);
unix(unixCommand);

cd(oldFolder);

end