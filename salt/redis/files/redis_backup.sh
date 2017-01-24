#!/bin/bash
REDISCLI="/usr/local/webserver/redis-{{ PORT }}/bin/redis-cli -p {{ PORT }}  -a {{ PASSWD }}" 
LOGFILE="/usr/local/webserver/redis-{{ PORT }}/log/keepalived-redis-state.log"
 
echo "[backup]" >> $LOGFILE
date >> $LOGFILE
echo "Being slave...." >> $LOGFILE 2>&1
echo "Run SLAVEOF cmd ..." >> $LOGFILE
$REDISCLI SLAVEOF {{ MASTER_IP }} {{ PORT }} >> $LOGFILE  2>&1  # IP为切换后主redis的IP
