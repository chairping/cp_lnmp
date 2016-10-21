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

. include/init.sh
cat << EOF
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +                         lnmp  一键安装包                              +
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +                                                                       +
 +                                                                       +
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
EOF

echo 
echo  " 请选择操作类型: "
cat << EOF
   1)  安装编译lnmp
   2)  打包lnmp
   3)  移植并初始化已编译好的lnmp一键安装包
EOF

echo -n " 请输入操作类型(按回车结束): "
read TYPE

case "$TYPE" in
1)
. lnmp_make.sh
;;
2)
echo "打包lnmp"
;;
3)
. lnmp_install.sh
;;
*)
echo 
Echo_Red "请输入正确的操作类型"
;;
esac
exit

