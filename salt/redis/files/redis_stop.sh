#!/bin/bash
# Author: zhaowei <wei.zhao1@example.com>
# description: An example of notify script
vip=192.168.1.234
contact='wei.zhao1@example.com'
notify() {
    mailsubject="`hostname` to be $1: $vip floating"
    mailbody="`date '+%F %H:%M:%S'`: vrrp transition, `hostname` changed to be stop"
    echo $mailbody | mail -s "$mailsubject" $contact
}
notify
LOGFILE="/usr/local/webserver/redis-{{ PORT }}/log/keepalived-redis-state.log"
echo "[fault]" >> $LOGFILE
date >> $LOGFILE
