#!/bin/sh
HOST="192.168.51.170"
USER="root"
PASSWORD="root"
echo "Get smxx smxxlog from $HOST"
echo -n '' > smxx_no_one_like_this_name.sql
echo "use smxx;" >> smxx_no_one_like_this_name.sql
echo "starting dumping smxx..."
mysqldump --add-drop-table -u${USER} -p${PASSWORD} -h ${HOST} smxx >> smxx_no_one_like_this_name.sql
echo "smxx update done"

echo -n '' > smxx_no_one_like_this_name_log.sql
echo "use smxx_log;" >> smxx_no_one_like_this_name_log.sql
echo "starting dumping smxx_log..."
mysqldump --add-drop-table -u${USER} -p${PASSWORD} -h ${HOST} smxx_log >> smxx_no_one_like_this_name_log.sql
mysql -u root -proot < smxx_no_one_like_this_name.sql
mysql -u root -proot < smxx_no_one_like_this_name_log.sql
echo "smxx_log update done"
rm -f smxx_no_one_like_this_name.sql
rm -f smxx_no_one_like_this_name_log.sql

