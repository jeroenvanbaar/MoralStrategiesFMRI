function RemoveRawDataFromMDrive(SUBJECT_NUMBER,SESSION_NUMBER)

s = GetSubjectProperties(SUBJECT_NUMBER, SESSION_NUMBER);

% remove data_raw using unix command
%--------------------------------------------------------------------------
unixCommand=sprintf('rm -r %s', s.dataRawPath);
unix(unixCommand);

end
