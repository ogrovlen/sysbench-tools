#!/usr/bin/bash

MAXTHREADS=4096
TIME=300
HOST=$1
TABLES=$2
ROWS=$3
TESTCONFIG=$4

echo $TESTCONFIG
if [[ $TESTCONFIG == mds* ]]
then
   ssh -i .ssh/oysteing-ssh.pem $HOST cat /etc/sysconfig/mysql
fi
# Warmup
sysbench --threads=128 --time=300 --rand-type=uniform --mysql-host=$HOST --mysql-user=mysql --mysql-password=mysql --mysql-ssl=REQUIRED --tables=$TABLES  --table-size=$ROWS sysbench/src/lua/oltp_point_select.lua run > /dev/null

for TEST in point_select read_only update_non_index read_write
do
  echo $TEST  
  sysbench_oltp.sh $TEST $HOST $TIME $TABLES $ROWS $MAXTHREADS $TESTCONFIG 
done
echo "END TEST"
