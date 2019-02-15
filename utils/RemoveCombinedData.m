% -------------------------------------------------------------------------
% function RemoveCombinedData( SUBJECT_NUMBER, SESSION_NUMBER)
% 
%   removes files 'crf*.nii' from you M-drive
% ------------------------------------------------------------------------- 
% 
% Use this function once you have finished preprocessing the combined data
% and you are confident the result is fine.
% 
% ------------------------------------------------------------------------- 
function RemoveCombinedData( SUBJECT_NUMBER, SESSION_NUMBER)

% set default session number
if ~exist('SESSION_NUMBER','var')
    SESSION_NUMBER=1;
end

if ~exist('logs','dir'); mkdir('logs'); end
diary(['logs/cleanup_subject' num2str(SUBJECT_NUMBER) '.log'])
tic

% add path '../utils' to matlab PATH, without having relative path
% note: if this is not done, mfilename will return relative path, which
% might mess up other script, notably the GetSubjectProperties.m
[currentPath, ~, ~] = fileparts(mfilename('fullpath'));
pathParts = strsplit(currentPath,filesep);
addpath(sprintf('/%s/utils',fullfile(pathParts{1:(end-1)})));

% load subject specific details
s = GetSubjectProperties(SUBJECT_NUMBER, SESSION_NUMBER);

% remove all 'crf*.nii' files from the data_combined
unixCommand = sprintf('find %s -name ''crf*.nii'' -delete -print', s.dataPreprocessedPath);
[~, cmdout ] = unix(unixCommand);

% log deleted files
fprintf('following files where deleted:\n');
fpritnf('%s', cmdout);


end

