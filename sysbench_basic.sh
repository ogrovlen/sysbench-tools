#!/usr/bin/bash

MAXTHREADS=4096
TIME=300
HOST=$1
SIZE=$2
TESTCONFIG=$3

# Run short test
for TEST in point_select read_only update_non_index read_write
do
  echo $TEST  
  sysbench_oltp.sh $TEST $HOST $TIME $SIZE $MAXTHREADS $TESTCONFIG
done
echo "END TEST"
