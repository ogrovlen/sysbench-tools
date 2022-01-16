#!/usr/bin/bash

TEST=$1
HOST=$2
TIME=$3
TABLES=$4
ROWS=$5
MAXTHREADS=$6
TESTCONFIG=$7
TESTDIR=${HOME}/test/$6_$1

mkdir $TESTDIR
i=1
while [ $i -le $MAXTHREADS ]
do
  sysbench --threads=$i --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=mysql --mysql-ssl=REQUIRED --tables=$TABLES  --table-size=$ROWS sysbench/src/lua/oltp_${TEST}.lua run > $TESTDIR/sysbench_$i.out
  awk -F\( -v i=$i '/transactions:/ {print i, $2}' $TESTDIR/sysbench_$i.out | awk '{print $1, $2}'
  i=$(( 2*$i ))
done
