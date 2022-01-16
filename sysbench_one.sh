#!/usr/bin/bash

TEST=$1
HOST=$2
TIME=$3
ROWS=$4
THREADS=$5
TESTCONFIG=$6
TESTDIR=${HOME}/test/$6_$1

mkdir $TESTDIR
sysbench --threads=$THREADS --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=mysql --mysql-ssl=REQUIRED --tables=8  --table-size=$ROWS sysbench/src/lua/oltp_${TEST}.lua run > $TESTDIR/sysbench_$THREADS.out

