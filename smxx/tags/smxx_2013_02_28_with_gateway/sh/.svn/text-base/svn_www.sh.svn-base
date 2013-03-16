#!/bin/bash

cd /data/www/csj/html/flash
svn cat svn://113.107.160.8/csj/code/www/csj/html/flash/main.swf > main.swf
svn cat svn://113.107.160.8/csj/code/www/csj/html/flash/GameLoader.swf > GameLoader.swf

cd /data/www/csj/html/flash/assets
svn update

cd /data/www/csj/html/admin
svn update

cd /data/www/csj/php
svn update

echo 'UPDATE csj_www finish.'
