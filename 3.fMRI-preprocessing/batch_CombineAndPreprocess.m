% Script that defines the preprocessing pipeline:
% 1. Combine multi-echo recordings
% 2. Preprocess
% 3. Clean up intermediate files (with default SPM prefixes such as crf*)

partNrs = [124, 126]; % Add subject numbers here

addpath('../utils/');
LoadSPM;
spm_jobman('initcfg');
spm('defaults','FMRI');

%Configure qsub
memory_in_GB = 3;
time_in_hours  = 3;
memreq = memory_in_GB * 1024 *1024 * 1024;
timreq = time_in_hours * 60 * 60;
addpath /home/common/matlab/fieldtrip/qsub

% Combining
for i = 1:length(partNrs)
    partNr = partNrs(i);
    try
        fprintf(['Submitting comb for p' num2str(partNr) ' at ' datestr(now) '\n']);
        qsubfeval(@CombineSubject,partNr,1,'memreq', memreq*2, 'timreq', timreq);
    catch
        fprintf(['Failed comb for p' num2str(partNr) ' at ' datestr(now) '\n']);
    end
end

% Preprocessing
for i = 1:length(partNrs)
    partNr = partNrs(i);
    try
        fprintf(['Submitting prep for p' num2str(partNr) ' at ' datestr(now) '\n']);
        qsubfeval(@PreprocessSubject,partNr,1,'memreq', memreq, 'timreq', timreq);
    catch
        fprintf(['Failed prep for p' num2str(partNr) ' at ' datestr(now) '\n']);
    end
end

% Clean-up
for i = 1:length(partNrs)
    partNr = partNrs(i);
    if exist(['../../3014018.02_jervbaa_' num2str(partNr) '_001'])==7
    try
        fprintf(['Starting CleanUp for p' num2str(partNr) ' at ' datestr(now) '\n']);
        delete(['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1/crf*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1/f*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1/rf*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2/crf*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2/f*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2/rf*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1/ac*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1/wa*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2/ac*'],...
            ['../../3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2/wa*']);
        fprintf(['Completed CleanUp for p' num2str(partNr) ' at ' datestr(now) '\n']);
    catch
        fprintf(['Failed CleanUp for p' num2str(partNr) ' at ' datestr(now) '\n']);
    end
    else
        fprintf(['Skipped CleanUp for p' num2str(partNr) ' at ' datestr(now) ' (no such folder)\n']);
    end
end
