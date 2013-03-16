#!/bin/sh
cd ..
rm -fR temp
mkdir temp
cd temp

erlc -I ../include/ ../src/lib/mysql/mysql_auth.erl
erlc -I ../include/ ../src/lib/mysql/mysql_conn.erl
erlc -I ../include/ ../src/lib/mysql/mysql_recv.erl
erlc -I ../include/ ../src/lib/mysql/mysql.erl
erlc -I ../include/ ../src/lib/mysql/db_mysqlutil.erl
erlc -I ../include/ ../src/lib/erlydb/erlsql.erl
erlc -I ../include/ ../src/lib/erlydb/erlydb.erl
erlc -I ../include/ ../src/lib/erlydb/erlydb_base.erl
erlc -I ../include/ ../src/lib/erlydb/erlydb_field.erl
erlc -I ../include/ ../src/lib/erlydb/erlydb_mysql.erl
erlc -I ../include/ ../src/lib/erlydb/smerl.erl
#erlc -I ../include/ ../src/lib/db_sql.erl
erlc -I ../include/ ../src/misc/tool.erl
erlc -I ../include/ ../src/tools/table_to_erlang.erl


echo "current dir: " `pwd`
erl +P 1024000 -smp disable -name csj_tool@127.0.0.1 -s table_to_erlang start

cd ..
rm -rf temp
echo "all done"

