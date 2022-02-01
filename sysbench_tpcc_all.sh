#!/usr/bin/bash

MAXTHREADS=4096
TIME=300
HOST=$1
TESTCONFIG=$2

echo $TESTCONFIG
if [[ $TESTCONFIG == mds* ]]
then
   ssh -i .ssh/oysteing-ssh.pem $HOST cat /etc/sysconfig/mysql
fi

for SCALE in 100 1000 10000
do
  echo $TEST  
  sysbench_tpcc.sh $HOST $SCALE $TIME $MAXTHREADS $TESTCONFIG 
done
echo "END TEST"
