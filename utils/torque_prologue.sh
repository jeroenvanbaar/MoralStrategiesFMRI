#!/bin/sh
# Create TMPDIR /data/$user/$jobid
# prologue gets 3 arguments:
# 1 -- jobid
# 2 -- userid
# 3 -- grpid
#
jobid=$1
user=$2
group=$3

tmp=/data/$user/$jobid

echo "---------------------------"
echo "running custom prologue script $0"
echo ""
echo "trying to create working directory $tmp"

mkdir -m 700 $tmp 
chown $user.$group $tmp

if [ -d $tmp ] ; then
  echo "created working-directory for current job at $tmp"
else
  echo "WARNING: working-directory $tmp was NOT created."
  # an exist status of '1' means the job will be aborted
  # comment the following out, if your script can handle 
  # a missing working directory (e.g. by working on your 
  # M-drive)
  exit 1
fi

echo "---------------------------"
echo ""

exit 0