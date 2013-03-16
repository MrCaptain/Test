#!/bin/bash

#cd /data/www/csj/html/flash
#svn cat svn://113.107.160.8/csj/code/www/csj/html/flash/main.swf > main.swf

#cd /data/www/csj/html/flash/assets
#svn update

#cd /data/www/csj/html/admin
#svn update

#cd /data/www/csj/php
#svn update 

ROOT_DD='/data/erlang/csj/'
DATETIME=`date "+%Y%m%d%H%M%S"`
cd ${ROOT_DD}

svn update
chmod 777 *

./sh/make.sh

echo 'UPDATE finish.'

SVN_PATH="/usr/local/svn/bin"

cd /data/erlang/csj/logs
mkdir $DATETIME
mv *.log $DATETIME
/bin/tar zcvf $DATETIME.tar.gz $DATETIME >/dev/null 2>&1
rm -rf $DATETIME/*
mv $DATETIME.tar.gz $DATETIME/
echo 'Backup logs finished.'
