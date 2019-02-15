matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'run1';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{''}};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'run2';
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{''}};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: run1(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^swa*';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: run2(1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^swa*';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{5}.spm.stats.fmri_spec.dir = {''};
matlabbatch{5}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{5}.spm.stats.fmri_spec.timing.RT = 2.25;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t = 35;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t0 = 18;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^swa*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Face';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Investment';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).duration = [1
                                                               2
                                                               8];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).pmod.name = 'InvestmentLevel';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).pmod.param = [1
                                                                 2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).pmod.poly = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(3).name = 'MultiplierX2';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(3).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(3).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(4).name = 'MultiplierX4';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(4).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(4).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(5).name = 'MultiplierX6';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(5).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(5).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(6).name = 'DecisionX2';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(6).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(6).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(6).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(7).name = 'DecisionX4';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(7).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(7).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(7).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(8).name = 'DecisionX6';
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(8).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(8).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(1).cond(8).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{5}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{5}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
matlabbatch{5}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^swa*)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).name = 'Face';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).name = 'Investment';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).duration = [1
                                                               2
                                                               8];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).pmod.name = 'InvestmentLevel';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).pmod.param = [1
                                                                 2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).pmod.poly = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(3).name = 'MultiplierX2';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(3).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(3).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(4).name = 'MultiplierX4';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(4).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(4).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(5).name = 'MultiplierX6';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(5).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(5).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(5).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(6).name = 'DecisionX2';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(6).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(6).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(6).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(7).name = 'DecisionX4';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(7).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(7).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(7).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(8).name = 'DecisionX6';
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(8).onset = [1
                                                            2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(8).duration = [1
                                                               2];
matlabbatch{5}.spm.stats.fmri_spec.sess(2).cond(8).tmod = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{5}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{5}.spm.stats.fmri_spec.sess(2).multi_reg = {''};
matlabbatch{5}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{5}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{5}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{5}.spm.stats.fmri_spec.volt = 1;
matlabbatch{5}.spm.stats.fmri_spec.global = 'None';
matlabbatch{5}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{5}.spm.stats.fmri_spec.mask = {''};
matlabbatch{5}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{6}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{6}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{6}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{7}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{7}.spm.stats.con.consess{1}.tcon.name = 'Inv-Investment';
matlabbatch{7}.spm.stats.con.consess{1}.tcon.weights = contrastParser('5 + 28');
matlabbatch{7}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{7}.spm.stats.con.delete = 0;
