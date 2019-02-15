function CopyRawDataFromDToMDrive(SUBJECT_NUMBER, SESSION_NUMBER, WINDOWS_PC_ID)

s = GetSubjectProperties(SUBJECT_NUMBER, SESSION_NUMBER);

% figure out, where raw data should be:
% -------------------------------------------------------------------------
dirMdrive = s.dataRawPath;
[~, ~, ~] = mkdir(dirMdrive);

% figure out, where raw data are on D-drive
% -------------------------------------------------------------------------
% were assuming: D:\projects\3014030.01 and M:\projects\3014030.01 or
% something similar; so, removing /home/group/username from 'dirMdrive'
% will get use the location of the 
% get home path for current user
homePath = getenv('HOME'); % e.g. /home/decision/petvav
% remove homepath from targetFolder
dirDdrive = strrep(dirMdrive, [homePath '/'], '');

% call shell script to handle the actual access & copying
% -------------------------------------------------------------------------
unixCommand = sprintf('copyFromDDrive %s %s %s', WINDOWS_PC_ID, dirDdrive, dirMdrive);
unix(unixCommand); % suppress file listings

end