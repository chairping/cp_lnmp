#!/usr/bin/env bash

# Ìí¼ÓÓÃ»§
#insert into mysql.user(Host,User,Password) values("192.168.5.1","test",password("1234"));
/opt/lnmp/mysql/bin/mysql << EOF
DELETE FROM mysql.user WHERE User="";
flush privileges;
EOF

