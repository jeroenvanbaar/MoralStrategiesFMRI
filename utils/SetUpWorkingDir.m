function [workingDir, neededToCreateDir] = SetUpWorkingDir(emergencyWorkingPath)

% define a working directory
j = GetJobinfo();
if j.workingDir
    % use the working directory already created by prologue script
    workingDir = j.workingDir;
    neededToCreateDir = false;
else
    % try to create folder '/data/$user/$jobinfo'
    try
        workingDir = sprintf('/data/%s/%s',j.username,j.jobid);
        mkdir(workingDir)
        if exist(workingDir,'dir')
            fprintf('SetUpWorkingDir: working directory succesfully created using Mablab');
        else
            error('SetUpWorkingDir: mkdir did not work on /data');
        end
    catch
        % if we cannot create '/data/$user/$jobinfo', then use
        % emergencyWorkingPath
        warning('WARNING: DATA MIGHT BE OVERWRITTEN. No working directory available on mentat node. Going to use folder "%s" as working directory', emergencyWorkingPath);
        workingDir = emergencyWorkingPath;
        mkdir(workingDir);
    end
    neededToCreateDir = true;
end

% assert expected status of working directory
assert(exist(workingDir,'dir')==7,'Error: workingPath not created');
[~, workingDirAccess] = fileattrib(workingDir);
assert(workingDirAccess.UserRead==1,'No reading rights for working directory "%s"',workingDir);
assert(workingDirAccess.UserWrite==1,'No writing rights for working directory "%s"',workingDir);
    
end