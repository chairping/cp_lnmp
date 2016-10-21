#!/bin/bash

modify_root_password() {
    # 获取IP# 获取IP
    ip=$(/sbin/ifconfig eth0 2>/dev/null|awk '/net addr:/{print substr($2,6)}')
    if [ -z "$ip" ]; then
        echo "Input local ip:"
        read ip
    fi

    ip_item=`echo "$ip"|awk -F '.' '{print $4}'`

    # 修改密码
    echo "wewin$ip_item"|passwd --stdin root
}

Install_MySQL_56() {

    Echo_Blue "[+] Installing ${Mysql_Ver}..."

    groupadd mysql
    useradd -r -g mysql -s /bin/false mysql

    rm -f /etc/my.cnf
    Tar_Cd ${Mysql_Ver}.tar.gz ${Mysql_Ver}
    cmake \
    -DCMAKE_INSTALL_PREFIX=${LNMP_PATH}/mysql \
    -DSYSCONFDIR=${LNMP_PATH}/mysql \
    -DMYSQL_UNIX_ADDR=${LNMP_PATH}/mysql/mysql.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DMYSQL_DATADIR=${LNMP_PATH}/mysql/data

    make
    make install

    cp  ${cur_dir}/conf/my.cnf ${LNMP_PATH}/mysql

    cd ${LNMP_PATH}/mysql
    chown -R mysql .
    chgrp -R mysql .
    scripts/mysql_install_db --user=mysql
    bin/mysqld_safe --user=mysql &
    chown -R root .
    chown -R mysql data
    cp support-files/mysql.server ${LNMP_PATH}/init.d/mysql
    chmod +x ${LNMP_PATH}/init.d/mysql

    #rm -rf CMakeCache.txt

    Echo_Blue "[+] 注册mysql/lib 共享库"
    cat > /etc/ld.so.conf.d/lnmp.conf<<EOF
    /opt/lnmp/mysql/lib
EOF
    ldconfig -v

    chown mysql:mysql ${LNMP_PATH}/mysql

}
