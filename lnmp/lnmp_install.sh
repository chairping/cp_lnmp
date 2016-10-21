#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

. include/common.sh

#tar -czf small.tar.gz small(目录名)  ;压缩并打包目录
cur_dir=$(pwd)

cat /etc/ld.so.conf.d/lnmp.conf<<EOF
/opt/lnmp/mysql/lib
EOF

ldconfig -v

LNMP_PATH='/opt/lnmp'
LNMP_INITD=/opt/lnmp/init.d

Install_Libmcrypt() {
    Echo_Blue "[+] Installing libmcrypt-2.5.7"
    Tar_Cd libmcrypt-2.5.7.tar.gz libmcrypt-2.5.7
    ./configure
    ake
    make install
}

groupadd mysql
useradd -r -g mysql -s /bin/false mysql

groupadd www
useradd -s /sbin/nologin -g www www
useradd -c php-fpm-user -g www -M php-fpm

tar zxvf ${cur_dir}/lnmp.tar.gz -C /opt

RemoveAMP

Set_Timezone

InstallNTP

Dependent

Install_Libmcrypt

Lnmp_Start
