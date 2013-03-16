#!/bin/sh
NODE=0
COOKIE=smxx4399
##Get the IP Address.
IPADDR=`ifconfig eth0 | grep -m 1 'inet addr' | awk '{print $2}' | sed -e "s/addr\://"`
NODE_NAME=game_gateway@${IPADDR}

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
LOG_PATH="../logs/app_gw.$DATETIME.log" 

cd ../config
erl +P $ERL_PROCESSES \
    +K $POLL \
    -smp $SMP \
    -pa ../ebin \
    -name $NODE_NAME \
    -setcookie $COOKIE \
    -boot start_sasl \
    -kernel inet_dist_listen_min 9001 inet_dist_listen_max 9009 \
    -kernel error_logger \{file,\"$LOG_PATH\"\} \
    -config gateway  \
    -s main gateway_start
