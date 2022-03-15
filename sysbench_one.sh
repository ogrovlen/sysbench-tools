#!/usr/bin/bash

TEST=$1
HOST=$2
TIME=$3
TABLES=$4
ROWS=$5
THREADS=$6
TESTCONFIG=$7
TESTDIR=${HOME}/test/$7_$1

mkdir $TESTDIR
echo "sysbench --threads=$THREADS --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=MySQL?123 --mysql-ssl=REQUIRED --tables=$TABLES  --table-size=$ROWS sysbench/src/lua/oltp_${TEST}.lua run" > $TESTDIR/sysbench_$THREADS-long.out
sysbench --threads=$THREADS --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=MySQL?123 --mysql-password=mysql --mysql-ssl=REQUIRED --tables=$TABLES  --table-size=$ROWS sysbench/src/lua/oltp_${TEST}.lua run >> $TESTDIR/sysbench_$THREADS-long.out

