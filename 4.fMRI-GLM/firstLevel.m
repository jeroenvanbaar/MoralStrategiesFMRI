function firstLevel(partNr,initializeSPM,modelName)

if initializeSPM == 1
% setup
addpath('../utils');
LoadSPM();
spm_jobman('initcfg');
spm('defaults','FMRI');
end

% setup matlabbatch variable
cd(['/project/3014018.02/analysis_mri/' modelName])
clear matlabbatch;
run('firstLevel_job.m');

% overwrite personal folder paths
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = ...
    {{['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1']}};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = ...
    {{['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2']}};
matlabbatch{5}.spm.stats.fmri_spec.dir = ...
    {['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/' modelName]};

% overwrite stimulus levels and onsets
%Load
load(['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/Behavior/fMRI/sots1']);
load(['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/Behavior/fMRI/sots2']);
%Faces run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).onset = sots1.faces.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).duration = sots1.faces.durations;
%Investments run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).onset = sots1.investments.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).duration = sots1.investments.durations;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).pmod.param = sots1.investments.levels.unstand;
%Multiplier x2 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(3).onset = sots1.mult2.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(3).duration = sots1.mult2.durations;
%Multiplier x4 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(4).onset = sots1.mult4.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(4).duration = sots1.mult4.durations;
%Multiplier x6 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(5).onset = sots1.mult6.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(5).duration = sots1.mult6.durations;
%Decisions x2 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(6).onset = sots1.decision.x2.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(6).duration = sots1.decision.x2.durations;
%Decisions x4 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(7).onset = sots1.decision.x4.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(7).duration = sots1.decision.x4.durations;
%Decisions x6 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(8).onset = sots1.decision.x6.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(8).duration = sots1.decision.x6.durations;

%Faces run 2
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).onset = sots2.faces.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).duration = sots2.faces.durations;
%Investments run 2
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).onset = sots2.investments.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).duration = sots2.investments.durations;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).pmod.param = sots2.investments.levels.unstand;
%Multiplier x2 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(3).onset = sots2.mult2.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(3).duration = sots2.mult2.durations;
%Multiplier x4 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(4).onset = sots2.mult4.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(4).duration = sots2.mult4.durations;
%Multiplier x6 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(5).onset = sots2.mult6.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(5).duration = sots2.mult6.durations;
%Decisions x2 run 
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(6).onset = sots2.decision.x2.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(6).duration = sots2.decision.x2.durations;
%Decisions x4 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(7).onset = sots2.decision.x4.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(7).duration = sots2.decision.x4.durations;
%Decisions x6 run 1
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(8).onset = sots2.decision.x6.onsets;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(8).duration = sots2.decision.x6.durations;

% overwrite movement regressors
rp1path = ls(['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1/rp*']);
rp2path = ls(['/project/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2/rp*']);
matlabbatch{5}.spm.stats.fmri_spec.sess(1).multi_reg = {rp1path};
matlabbatch{5}.spm.stats.fmri_spec.sess(2).multi_reg = {rp2path};
if partNr == 190
    fprintf('Spikes regressed out for sub %i\n',partNr);
end

% run batch
spm_jobman('run', matlabbatch);

end