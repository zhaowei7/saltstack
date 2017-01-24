#!/bin/bash 

ALIVE=`/usr/local/webserver/redis-{{ PORT }}/bin/redis-cli -p {{ PORT }}  -a {{ PASSWD }} PING`
if [ "$ALIVE" == "PONG" ]; then
  echo $ALIVE 
  exit 0
else
  echo $ALIVE 
  exit 1
fi
