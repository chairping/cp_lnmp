#!/bin/bash
#
#
# Written by: cp

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

. include/var.sh
. include/init.sh
. include/php.sh
. include/mysql.sh
. include/nginx.sh
. include/php.sh
. include/end.sh


Disable_Selinux()
{
    Echo_Blue "[-] 关闭selinux..."
    if [ -s /etc/selinux/config ]; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    fi

    setenforce 0
}

Disable_Selinux


Disable_Firewalld() {
    Echo_Blue "[-] 关闭防火墙..."
    systemctl stop firewalld.service
    systemctl disable firewalld.service
}

Disable_Firewalld


# 升级系统软件至最新版本
System_Update() {
	yum -y update
}

# 卸载Apache mysql php
RemoveAMP()
{
    Echo_Blue "[-] Yum remove packages..."
    rpm -qa|grep httpd
    rpm -e httpd httpd-tools
    rpm -qa|grep mysql
    rpm -e mysql mysql-libs
    rpm -qa|grep php
    rpm -e php-mysql php-cli php-gd php-common php

    yum -y remove httpd*
    yum -y remove mysql-server mysql mysql-libs
    yum -y remove php*
    yum clean all
}

# 设置时间
Set_Timezone()
{
    Echo_Blue "Setting timezone..."
    rm -rf /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

# ntp 时间同步
InstallNTP()
{
    Echo_Blue "[+] Installing ntp..."
    yum install -y ntp
    ntpdate -u pool.ntp.org
    date
}

Create_dir() {
    Echo_Blue "[+] create dir..."

}


# 安装依赖包
Dependent()
{
#    cp /etc/yum.conf /etc/yum.conf.lnmp
  #  sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf
  # yum install libmemcached libmemcached-devel zlib-devel

    Echo_Blue "[+] Yum installing dependent packages..."
    for packages in net-tools cyrus-sasl-devel vim-minimal cmake perl gcc make gcc-c++ openssl openssl-devel autoconf curl curl-devel gd gd-devel wget ncurses ncurses-devel libevent libevent-devel zlib zlib-devel openssl openssl-devel libxml2* vim-minimal pcre pcre-devel;
    do yum -y install $packages; done

#    mv -f /etc/yum.conf.lnmp /etc/yum.conf
}

System_Update

RemoveAMP

Set_Timezone

InstallNTP

Dependent

Install_MySQL_56

Install_Nginx_18

Install_PHP_56

End
