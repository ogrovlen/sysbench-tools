#!/usr/bin/bash

HOST=$1

for SCALE in 100 1000 10000
do
  echo TPCC_W$SCALE  
  sysbench /BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --mysql-storage-engine=InnoDB   --scale=$SCALE --tables=1 --mysql-user=mysql --mysql-password=MySQL?123   --mysql-host=$host --mysql-db=tpcc$SCALE --use_fk=2 --events=0 --threads=32 --mysql-ssl=REQUIRED --force_null=1 create
  sysbench /BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --mysql-storage-engine=InnoDB   --scale=$SCALE --tables=1 --mysql-user=mysql --mysql-password=MySQL?123   --mysql-host=$host --mysql-db=tpcc$SCALE --use_fk=2 --events=0 --threads=32 --mysql-ssl=REQUIRED --force_null=1 prepare
done
echo "END TEST"
