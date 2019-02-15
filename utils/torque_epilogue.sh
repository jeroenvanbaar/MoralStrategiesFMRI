#!/bin/sh
# Clear out TMPDIR /data/$user/$jobid
# epilogue gets 9 arguments:
# 1 -- jobid
# 2 -- userid
# 3 -- grpid
# 4 -- job name
# 5 -- sessionid
# 6 -- resource limits
# 7 -- resources used
# 8 -- queue
# 9 -- account
#
jobid=$1
user=$2
group=$3

tmp=/data/$user/$jobid
echo "---------------------------"
echo "running custom epilogue script $0"
echo ""

if [ -d $tmp ]
then
  rm -rf $tmp
  if [ -d $tmp ]
  then
    echo "unable to delete $tmp... leaving it for the scheduled clean-up in 2 weeks."
  else
    echo "working directory $tmp removed"
  fi
else 
  echo "no working directory to remove; we're done"
fi

echo "---------------------------"
echo ""


exit 0