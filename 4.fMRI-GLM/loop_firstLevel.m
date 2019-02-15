
partNrs = [124,126]; % Add subject numbers here
modelName = 'GLM';
modelPath = ['/project/3014018.02/analysis_mri/' modelName]; % Change to project directory
cd(modelPath);

addpath('../utils/');
LoadSPM;
spm_jobman('initcfg');
spm('defaults','FMRI');

%Configure qsub
memory_in_GB = 8;
time_in_hours  = 1;
memreq = memory_in_GB * 1024 *1024 * 1024;
timreq = time_in_hours * 60 * 60;
addpath /home/common/matlab/fieldtrip/qsub

for i = 1:length(partNrs)
    partNr = partNrs(i);
    try
        fprintf(['Submitting model ' modelName ' at first level for p' num2str(partNr) ' at ' datestr(now) '\n']);
        qsubfeval(@firstLevel,partNr,0,modelName,'memreq', memreq, 'timreq', timreq);
%         fprintf(['Completed model ' modelName ' at first level for p' num2str(partNr) ' at ' datestr(now) '\n']);
    catch
        fprintf(['Failed model ' modelName ' at first level for p' num2str(partNr) ' at ' datestr(now) '\n']);
    end
end

% movefile('jervbaa_dccn_c*','clusterLogs');