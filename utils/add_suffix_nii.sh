#!/bin/bash
#
# rename files 'filename.nii' in folder 'run1' to 'filename.run1.nii' 
# ie include the folder-name as a suffix, just before the extension '.nii'
# 
# usage 1:
# 	add_suffix_nii.sh # will run in current folder
# 
# usage 2: 
#	add_suffix_nii.sh /path/to/folder1 /path/to/folder2 # will run in specified folders
#
# usage 3:
# 	HINT: check the output of 'find' before piping to add_suffix_nii
#	cd path/to/project # e.g. /home/peter/projects/3014030.01
#	find -type d -name 'run*' | xargs add_suffix_nii.sh # run in all folders like 'run1','run2',etc.


echo "adding suffix to .nii files"

function add_suffix {
# get folder name of pwd, without full path 
# cf. https://stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-bash-script
suffix=${PWD##*/} # use this as an suffix

echo $suffix
# for all files in pwd, add suffix before file extension (ie. the ".nii")
# cf https://unix.stackexchange.com/questions/56810/adding-text-to-filename-before-extension
for f in *.nii; do 
  name_base=${f%.nii}
  
  # skip current file, if it already contains the suffix
  if [[ $name_base == *"$suffix" ]]; then continue; fi
  
  name_new="$name_base.$suffix.nii"
  mv $f $name_new
done
}

# if taking any argument, then change folder to run the script there
if [[ $# -gt 0 ]]; then
  old_pwd=${PWD}
  for folder in "$@"; do
    if [ -d $folder ]; then
	cd $folder
	echo "adding suffix in folder $folder"
	add_suffix
	cd $old_pwd
    else
	echo "$folder is not a folder"
    fi
  done
else
  echo "adding suffix in current folder ${PWD}"
  add_suffix
fi
