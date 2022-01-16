#!/usr/bin/bash

MAXTHREADS=4096
TIME=300
HOST=$1
TABLES=$2
ROWS=$3
TESTCONFIG=$4

# Run short test
echo $TESTCONFIG
for TEST in point_select read_only update_non_index read_write
do
  echo $TEST  
  sysbench_oltp.sh $TEST $HOST $TIME $TABLES $ROWS $MAXTHREADS $TESTCONFIG
done
echo "END TEST"
