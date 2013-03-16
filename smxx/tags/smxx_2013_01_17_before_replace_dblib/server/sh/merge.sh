#!/bin/sh

NODE=1
COOKIE=csj1608
NODE_NAME=csj_merge@127.0.0.1

ulimit -SHn 102400

# define default configuration
POLL=true
SMP=auto
ERL_MAX_PORTS=32000
ERL_PROCESSES=500000
ERL_MAX_ETS_TABLES=1400

export ERL_MAX_PORTS
export ERL_MAX_ETS_TABLES

DATETIME=`date "+%Y%m%d%H%M%S"` 
LOG_PATH="../logs/app_$NODE.$DATETIME.log" 

cd ../config
erl +P $ERL_PROCESSES \
    +K $POLL \
    -smp $SMP \
    -pa ../ebin \
    -name $NODE_NAME
    
   