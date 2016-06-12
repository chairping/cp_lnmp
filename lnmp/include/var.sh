#!/bin/bash

#####################################
 #               变量定义            #
#####################################

cur_dir=$(pwd) #当前路径

Nginx_Ver='nginx-1.8.1'
Mysql_Ver='mysql-5.6.29'
Php_Ver='php-5.6.19'

LNMP_PATH='/opt/lnmp'          #lnmp 安装目录
LNMP_INITD='/opt/lnmp/init.d'  # nmp 启动脚本

mkdir /opt/lnmp
mkdir /opt/lnmp/init.d
mkdir /opt/lnmp/mysql

chmod 755 -R /opt/lnmp/mysql

####### web 用户设置 ######
web_user='www'

groupadd $web_user
useradd -s /sbin/nologin -g $web_user $web_user
useradd -s /sbin/nologin -g $web_user ${php-fpm-user}



nginx_user=www
nginx_group=www

