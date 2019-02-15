function  DoRemovePrescanVolumes( SUBJECT_NUMBER, SESSION_NUMBER)
% =========================================================================
%                             WARNING:
% 1) Running this function twice for the same subject might remove too many
% volumes! 
% 2) This function assumes runs are sorted into different subfolders, incl.
% the motion parameters!
%
%                           USER BEWARE !
% =========================================================================
%
% % DoRemovePrescanVolumes takes the prescans and puts them into folder/zips
% them, and moves the associated motion parameters into a separate file.
%
% This convenience function can be used to take the prescans of each run
% and put them into a separate folder, and optionally zips the folder.
% It assumes the first N volumes of each run are the prescans, where N is
% taken from the subject's scans_metadata.m file.
% In
%
% There is a 'undo' function that tries to unzip and re-integrate those
% files.

% -------------------------------------------------------------------------
% USER SETTINGS:
% -------------------------------------------------------------------------

ZIP_PRESCANS = true;
FOLDER_NAME_PRESCANS = 'prescans';
FILENAME_MOTION_PARAMETERS = 'rp_prescans.txt';

% -------------------------------------------------------------------------

% set default session number
if ~exist('SESSION_NUMBER','var')
    SESSION_NUMBER=1;
end

% add path '../utils' to matlab PATH, without having relative path
% note: if this is not done, mfilename will return relative path, which
% might mess up other script, notably the GetSubjectProperties.m
[currentPath, ~, ~] = fileparts(mfilename('fullpath'));
pathParts = strsplit(currentPath,filesep);
addpath(sprintf('/%s/utils',fullfile(pathParts{1:(end-1)})));


oldFolder = pwd;

s = GetSubjectProperties(SUBJECT_NUMBER, SESSION_NUMBER);
nRuns = length(s.runSeries);

for iRun = 1:nRuns
    fprintf('Handling files of run %i\n', iRun);
    
    % go to folder with data preprocessed images, of a run
    folderData = sprintf('%s/run%i',s.dataPreprocessedPath, iRun);
    cd(folderData);
    
    % skip if already a prescans zip file exists
    zipFileName = sprintf('%s.tar.gz',FOLDER_NAME_PRESCANS);
    if exist(zipFileName,'file')
        warning('A zip-file %s which could contain already zipped prescans was found for run %i. Not doing anything for this run.',zipFileName, iRun);
        continue
    end
    
    % create new folder for prescans
    mkdir(FOLDER_NAME_PRESCANS);
    
    % move first N images (all preprocessing stages, if present) into subfolder
    filePrefixes = {'swacrf', 'wacrf', 'acrf', 'crf'};
    for i=1:numel(filePrefixes);
        filePrefix = filePrefixes{i};
        
        % first check that there are not already files in the prescans folder,
        % that match current file filter and number of prescans
        % NOTE: this will not detect any zipped files.. 
        unixCommand = sprintf('find %s -maxdepth 1 -type f -name ''%s*.nii'' | wc -l', FOLDER_NAME_PRESCANS, filePrefix);
        [~, cmdResult] = unix(unixCommand);
        cmdResult = str2double(cmdResult);
        % IF YOU ARE SURE, comment the if clause out, and leave only the
        % first part. YOU MIGHT REMOVE TOO MANY FILES. ONLY DO THIS IF YOU
        % KNOW WHY!
        if cmdResult == 0 % i.e. no files found in prescans folder
            % move prescans to prescan folder
            unixCommand = sprintf('find . -maxdepth 1 -type f -name ''%s*.nii'' | sort | head -%i | xargs -r mv -v -t %s', filePrefix, s.nWeightVolumes, FOLDER_NAME_PRESCANS);
            [~, cmdResult] = unix(unixCommand);
            if ~isempty(cmdResult) % if files where moved, print that to the console
                disp(cmdResult)
            end
        else
            warning ('There are already %i files matching ''%s*.nii'' in the ''%s'' folder. No files are being moved with this pattern.\n', cmdResult, filePrefix, FOLDER_NAME_PRESCANS);
        end
    end
    
    % move the first N motion parameters into separate file
    % first check that no motion regressors present in prescans folder
    filenameMotionParamsPrescans = fullfile( FOLDER_NAME_PRESCANS, FILENAME_MOTION_PARAMETERS);
    if exist(filenameMotionParamsPrescans, 'file')
        warning ('There is already a file matching the motion parameter filename (''%s'') in the prescans folder (''%s''). No motion parameters will be removed.', FILENAME_MOTION_PARAMETERS, FOLDER_NAME_PRESCANS);
    else
        % get name of motion parameters
        unixCommand = sprintf('find * -maxdepth 1 -type f -name ''rp_f*.txt''');
        [~, filenameMotionParamsOrig] = unix(unixCommand); filenameMotionParamsOrig = strtrim(filenameMotionParamsOrig);
        
        filenameTMP = sprintf('tmp_%s_%i.txt',datestr(now,30),randi(10000)); % uses timestamp & random number to ensure that ensure that tmp file is not a previous file which would get overwritten..
        
        % make backup of rp_*.txt file
        unixCommand = sprintf('cp %s backup_%s_%s.txt', filenameMotionParamsOrig, filenameMotionParamsOrig,datestr(now,30));
        unix(unixCommand);
        
        % move the first 
        % from: 
        % http://stackoverflow.com/questions/801004/move-top-1000-lines-from-text-file-to-a-new-file-using-unix-shell-commands
        unixCommand = sprintf('head -%i %s > %s; tail -n +%i %s > %s; cp %s %s; rm %s',...
            s.nWeightVolumes, ...
            filenameMotionParamsOrig, filenameMotionParamsPrescans,  ...
            s.nWeightVolumes+1,...
            filenameMotionParamsOrig, filenameTMP, ...
            filenameTMP, filenameMotionParamsOrig,...
            filenameTMP);
        unix(unixCommand);
        
    end
    
    % optional: zip folder
    if ZIP_PRESCANS
       unixCommand = sprintf('tar --remove-file -cpf %s.tar.gz %s', FOLDER_NAME_PRESCANS, FOLDER_NAME_PRESCANS);
       unix(unixCommand); 
    end
    
    cd(oldFolder);
end

end