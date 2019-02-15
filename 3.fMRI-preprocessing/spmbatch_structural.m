%-----------------------------------------------------------------------
% Job saved on 28-Apr-2015 08:52:19 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'raw DICOM folder';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{'/home/decision/petvav/projects/3014030.01/3014030.01_petvav_001_001/data_raw'}};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: raw DICOM folder(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'overwrite_for_custom_filter';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/home/decision/petvav/projects/3014030.01/3014030.01_petvav_001_001'};
matlabbatch{3}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'data_structural';
matlabbatch{4}.spm.util.import.dicom.data(1) = cfg_dep('File Selector (Batch Mode): Selected Files (overwrite_for_custom_filter)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.util.import.dicom.root = 'flat';
matlabbatch{4}.spm.util.import.dicom.outdir(1) = cfg_dep('Make Directory: Make Directory ''data_structural''', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{4}.spm.util.import.dicom.protfilter = '.*';
matlabbatch{4}.spm.util.import.dicom.convopts.format = 'nii';
matlabbatch{4}.spm.util.import.dicom.convopts.icedims = 0;