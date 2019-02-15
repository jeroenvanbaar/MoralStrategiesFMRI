function jobinfo = GetJobinfo()
%GET_JOBID provide info related to torque job
% 
% returns a structure with the following fields
%   jobid
%   workingDir
%   username

[status jobinfoString] = unix('cluster-jobinfo');

% parse jobinfo string
parts=strsplit(jobinfoString,'\n');

% parse job id
tmp=strsplit(parts{10},'qstat -f '); jobinfo.jobid = tmp{2};

% append username just for ease of use
[status tmp] = unix('whoami');
jobinfo.username = tmp(1:end-1); % whoami return also a '\n'

% check whether a working directory was created under
% /data/%username/$jobid
% if so, provide it via jobinfo.workingDir as string
% if not, provide false
workingDir = sprintf('/data/%s/%s',jobinfo.username,jobinfo.jobid);
if (exist(workingDir,'dir'))
    jobinfo.workingDir = workingDir;
else 
    fprintf('GetJobinfo: working directory %s NOT found\n', workingDir);
    jobinfo.workingDir = false;
end

end

