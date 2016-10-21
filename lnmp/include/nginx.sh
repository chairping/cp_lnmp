#!/bin/bash

Install_Nginx_18() {

    Echo_Blue "[+] Installing ${Nginx_Ver}... "

    Tar_Cd ${Nginx_Ver}.tar.gz ${Nginx_Ver}

    ./configure \
    --user=$nginx_user \
    --group=$nginx_group \
    --prefix=${LNMP_PATH}/nginx \
    --conf-path=${LNMP_PATH}/nginx/conf/nginx.conf \
    --with-http_ssl_module \
    --with-http_stub_status_module


    make
    make install

    cd ${cur_dir}

    #cp conf/nginx.conf ${LNMP_PATH}/nginx/conf/nginx.conf

    cat > ${LNMP_PATH}/nginx/conf/nginx.conf<<EOF
user  $nginx_user $nginx_group;
worker_processes  auto;
error_log   ${LNMP_PATH}/nginx/logs/error.log  crit;

pid        ${LNMP_PATH}/nginx/logs/nginx.pid;

events {
    use epoll;
    worker_connections  51200;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    server_names_hash_bucket_size 128;
    client_header_buffer_size     32k;
    large_client_header_buffers   4 32k;
    client_max_body_size          8m;

    sendfile          on;
    tcp_nopush        on;
    keepalive_timeout 60;
    tcp_nodelay       on;

    fastcgi_connect_timeout      300;
    fastcgi_send_timeout         300;
    fastcgi_read_timeout         300;
    fastcgi_buffer_size          64k;
    fastcgi_buffers              4 64k;
    fastcgi_busy_buffers_size    128k;
    fastcgi_temp_file_write_size 128k;
    fastcgi_intercept_errors     on;

    gzip              on;
    gzip_min_length   1k;
    gzip_buffers      4 16k;
    gzip_http_version 1.0;
    gzip_comp_level   2;
    gzip_types        application/xml application/x-javascript text/css text/javascript text/plain;
    gzip_vary         on;
    gzip_disable      "MSIE [1-6].";

    server {
        listen      80 default;
        server_name _;
        root        /dev/null;
        location / {
            return     404;
            access_log off;
        }
    }

    log_format default '\$remote_addr - \$remote_user [\$time_local] \"\$request\" \$status \$body_bytes_sent "\$http_referer" "\$http_user_agent"
    \$http_x_forwarded_for';

    include vhost/*.conf;
}

EOF


    \cp tool/nginx ${LNMP_PATH}/init.d/nginx
    chmod +x ${LNMP_PATH}/init.d/nginx

}
