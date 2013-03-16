#!/bin/bash
ROOT_DD='/data/erlang/smxx/'
DATETIME=`date "+%Y%m%d%H%M%S"`

cd ${ROOT_DD}
echo 'Update source from SVN...'
svn update
./sh/make_all.sh
echo 'Update finish.'

echo 'Update database....'
./sh/updatedb.sh
echo 'Update database done'

cd /data/erlang/smxx/logs
mkdir $DATETIME
mv *.log $DATETIME
/bin/tar zcvf $DATETIME.tar.gz $DATETIME >/dev/null 2>&1
rm -rf $DATETIME/*
mv $DATETIME.tar.gz $DATETIME/
echo 'Backup logs finished.'
