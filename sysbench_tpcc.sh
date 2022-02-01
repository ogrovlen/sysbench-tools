#!/usr/bin/bash

HOST=$1
SCALE=$2
TIME=$3
MAXTHREADS=$4
TESTCONFIG=$5
DB=tpcc${SCALE}
TESTDIR=${HOME}/test/${TESTCONFIG}_${DB}

mkdir $TESTDIR
echo $TESTDIR
# Warmup
sysbench /BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --threads=128 --scale=$SCALE --time=$TIME --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=mysql --mysql-ssl=REQUIRED --mysql-db=$DB --tables=1 --events=0 --thread-init-timeout=0 --rate=0 run > /dev/null
i=1
while [ $i -le $MAXTHREADS ]
do
  echo "sysbench /BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --threads=$i --scale=$SCALE --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=mysql --mysql-ssl=REQUIRED --mysql-db=$DB --tables=1 --events=0 --thread-init-timeout=0 --rate=0 run" > $TESTDIR/tpcc_$i.out
  sysbench /BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --threads=$i --scale=$SCALE --time=$TIME --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=mysql --mysql-ssl=REQUIRED --mysql-db=$DB --tables=1 --events=0 --thread-init-timeout=0 --rate=0 run >> $TESTDIR/tpcc_$i.out
  awk -F\( -v i=$i '/transactions:/ {print i, $2}' $TESTDIR/tpcc_$i.out | awk '{print $1, $2}' | tee -a $TESTDIR/summary.out
  i=$(( 2*$i ))
done
