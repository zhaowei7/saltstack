#!/bin/bash

REDISCLI="/usr/local/webserver/redis-{{ PORT }}/bin/redis-cli -p {{ PORT }}  -a {{ PASSWD }}"

LOGFILE="/usr/local/webserver/redis-{{ PORT }}/log/keepalived-redis-state.log"
echo "[master]" >> $LOGFILE
date >> $LOGFILE
echo "Being master...." >> $LOGFILE 2>&1

echo "Run SLAVEOF NO ONE cmd ..." >> $LOGFILE
$REDISCLI SLAVEOF NO ONE >> $LOGFILE 2>&1
