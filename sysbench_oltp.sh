#!/usr/bin/bash

TEST=$1
HOST=$2
TIME=$3
TABLES=$4
ROWS=$5
MAXTHREADS=$6
TESTCONFIG=$7
TESTDIR=${HOME}/test/${TESTCONFIG}_$TEST

mkdir $TESTDIR
mysql --host=$HOST -umysql -pMySQL?123 -e 'select * from performance_schema.global_variables' > $TESTDIR/global.cnf
i=1
while [ $i -le $MAXTHREADS ]
do
  echo "sysbench --threads=$i --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=MySQL?123 --mysql-ssl=REQUIRED --tables=$TABLES  --table-size=$ROWS --db-ps-mode=disable sysbench/src/lua/oltp_${TEST}.lua run" > $TESTDIR/sysbench_$i.out
  sysbench --threads=$i --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=MySQL?123 --mysql-ssl=REQUIRED --tables=$TABLES  --table-size=$ROWS --db-ps-mode=disable sysbench/src/lua/oltp_${TEST}.lua run >> $TESTDIR/sysbench_$i.out
  awk -F\( -v i=$i '/transactions:/ {print i, $2}' $TESTDIR/sysbench_$i.out | awk '{print $1, $2}' | tee -a $TESTDIR/summary.out
  i=$(( 2*$i ))
done
