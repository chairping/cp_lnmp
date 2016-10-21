#!/bin/bash

Color_Text() {
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red() {
  echo $(Color_Text "$1" "31")
}

Echo_Green() {
  echo $(Color_Text "$1" "32")
}

Echo_Yellow() {
  echo $(Color_Text "$1" "33")
}

Echo_Blue() {
  echo $(Color_Text "$1" "34")
}

Tar_Cd()
{
    local FileName=$1
    local DirName=$2
    cd ${cur_dir}/src
    [[ -d "${DirName}" ]] && rm -rf ${DirName}
    echo "Uncompress ${FileName}..."
    tar zxf ${FileName}
    echo "cd ${DirName}..."
    cd ${DirName}
}


Disable_Selinux()
{
    Echo_Blue "[-] 关闭selinux..."
    if [ -s /etc/selinux/config ]; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    fi

    setenforce 0
}


Disable_Firewalld() {
    Echo_Blue "[-] 关闭防火墙..."
    systemctl stop firewalld.service
    systemctl disable firewalld.service
}

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

Lnmp_Start() {

  cp ${cur_dir}/tool/lnmp /etc/init.d/lnmp
  cp ${cur_dir}/tool/lnmp /usr/bin/lnmp

  chmod +x /etc/init.d/lnmp

  service lnmp start
}

