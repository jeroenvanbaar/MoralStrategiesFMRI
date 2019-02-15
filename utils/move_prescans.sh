#!/bin/bash
# move first 30 .nii files into a folder called prescans_runX, with X being based on current folder run1, run2, etc.
#
# usage:
#		cd ~/projects/3014030.01
#		find . -type d -wholename './3014030.01_petvav_0*run?' -print0 |  xargs -0 move_prescans.sh

for folder in "$@"
do	
  old_folder=${PWD}
  cd $folder
	# get number of run, e.g. "3014030.01_petvav_001_001/data_combined/run3" should return 3
	wd=${PWD##*/} # save current working dir, without the full path (e.g. 'run3')
	run_number=${wd//[!0-9]/} # extract number

	# make new folder, parallel to run3, ie 'run3/../prescans_run3'
	out_folder="$PWD/../prescans_run$run_number"
  echo "creating prescans folder: $out_folder"
	mkdir $out_folder 

	# move first 30 files from run folder to prescans folder
	# based on: https://unix.stackexchange.com/questions/29214/copy-first-n-files-in-a-different-directory
	prescans=$(find * -type f -name 'crf*.nii' | sort | head -30) # get first 30 combined images
	# since this script can be called even after preprocessing (ie files containing this name, but having prefixes 	like 'a','w', we loop over all files and move all of them
  echo "moving files to $out_folder"
  for prescan in $prescans
  do
    # move all files containing the prescan string
    find * -type f -name "*$prescan" -exec mv {} $out_folder \;
  done

  cd $old_folder
done