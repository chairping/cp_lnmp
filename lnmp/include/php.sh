#!/bin/bash

Install_Libmcrypt() {
    Echo_Blue "[+] Installing libmcrypt-2.5.7"
    Tar_Cd libmcrypt-2.5.7.tar.gz libmcrypt-2.5.7
    ./configure
    make
    make install
}

Intall_Memached() {

    Install_Libmemcached

    Echo_Blue "[+] Installing memcached-1.4.25"
    Tar_Cd memcached-1.4.25.tar.gz memcached-1.4.25
    ./configure --prefix=${LNMP_PATH}/memcached --enable-64bit
    make
    make install
}

Install_Libmemcached() {
    Echo_Blue "[+] Installing libmemcached-1.0.18"
    Tar_Cd libmemcached-1.0.18.tar.gz libmemcached-1.0.18
    ./configure
    make
    make install

    \cp ${cur_dir}/tool/memcached ${LNMP_PATH}/init.d/memcached
    chmod +x ${LNMP_PATH}/init.d/memcached
}

Install_Redis() {

    Echo_Blue "[+] Installing libmemcached-1.0.18"
    Tar_Cd redis-3.0.7.tar.gz redis-3.0.7
    make
    make PREFIX=${LNMP_PATH}/redis install

    mkdir -p ${LNMP_PATH}/redis/etc/
    \cp redis.conf  ${LNMP_PATH}/redis/etc/

    sed -i 's/daemonize no/daemonize yes/g' ${LNMP_PATH}/redis/etc/redis.conf
    sed -i 's/# bind 127.0.0.1/bind 127.0.0.1/g' ${LNMP_PATH}/redis/etc/redis.conf

    cp ${cur_dir}/tool/redis /etc/init.d/redis
    chmod +x ${LNMP_PATH}/init.d/redis

}

Install_PHP_ext() {
   Echo_Blue "[+] Installing SeasLog ext"
   ${LNMP_PATH}/php/bin/pecl install seaslog-1.6.9

   Echo_Blue "[+] Installing Xhprof ext"
   ${LNMP_PATH}/php/bin/pecl install xhprof-0.9.4

   Echo_Blue "[+] Installing memcached ext"
   ${LNMP_PATH}/php/bin/pecl install memcached-2.2.0

   Echo_Blue "[+] Installing redis ext"
   ${LNMP_PATH}/php/bin/pecl install redis-2.2.8
}


Install_PHP_56()
{
   Install_Libmcrypt
   Intall_Memached
   Install_Redis

    Echo_Blue "[+] Installing ${Php_Ver}"
    Tar_Cd ${Php_Ver}.tar.gz ${Php_Ver}

    useradd -g www -M php-fpm

    ./configure \
    --prefix=${LNMP_PATH}/php \
    --with-config-file-path=${LNMP_PATH}/php/etc \
    --enable-fpm \
    --with-fpm-user=php-fpm \
    --with-fpm-group=www \
    --with-mysql=${LNMP_PATH}/mysql \
    --with-mysqli=${LNMP_PATH}/mysql/bin/mysql_config \
    --with-mysql-sock=${LNMP_PATH}/mysql/mysql.sock \
    --with-pdo-mysql=${LNMP_PATH}/mysql \
    --with-iconv-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-freetype-dir \
    --with-zlib \
    --with-libxml-dir=/usr \
    --enable-xml \
    --disable-rpath \
    --enable-bcmath \
    --with-curl \
    --enable-mbregex \
    --enable-mbstring \
    --with-gd \
    --with-openssl \
    --with-mhash \
    --enable-pcntl \
    --enable-sockets \
    --enable-zip \
    --enable-soap \
    --with-gettext \
    --disable-fileinfo

    make
    make install

    echo "Copy new php configure file..."
    # php extensions
    # cp conf/php.ini ${LNMP_PATH}/php/etc/php.ini
    cp ${cur_dir}/conf/php.ini ${LNMP_PATH}/php/etc/php.ini
    cp ${cur_dir}/conf/php-fpm.conf ${LNMP_PATH}/php/etc/php-fpm.conf

    echo "Copy php-fpm init.d file..."
    \cp ${cur_dir}/src/${Php_Ver}/sapi/fpm/init.d.php-fpm ${LNMP_PATH}/init.d/php-fpm
    chmod +x ${LNMP_PATH}/init.d/php-fpm

    Install_PHP_ext
}
