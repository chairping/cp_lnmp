#!/bin/bash

# 修改启动模式 (最小化下无需设置)
#sed -i 's/id:5/id:3/' /etc/inittab


######################  清空防火墙并设置规则 ################
iptables -F # 清除防火墙规则
#iptables -L # c=查看防火墙规则
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -P INPUT DROP
/etc/init.d/iptables save


# 修改最大句柄
ULIMIT=`ulimit -n`
if [ $ULIMIT != 65535 ]; then
    echo "* soft nofile 65535" >> /etc/security/limits.conf
    echo "* hard nofile 65535" >> /etc/security/limits.conf
    ulimit -SHn 65535
fi


# 修改系统默认语言为英文
sed -i 's/zh_CN/en_US/' /etc/sysconfig/i18n
# 修改颜色方案
cp /etc/DIR_COLORS /root/.dir_colors

# vim
echo 'syntax on' > /root/.vimrc
echo 'set number' >> /root/.vimrc

# 防止ping
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
/sbin/iptables -A INPUT -p icmp -j DROP

# 防止攻击
echo "net.ipv4.tcp_synack_retries=3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries=3" >> /etc/sysctl.conf

echo "multi on" >> /etc/host.conf
echo "nospoof on" >> /etc/host.conf

echo "* hard core 0" >> /etc/security/limits.conf
echo "* hard nproc 10240" >> /etc/security/limits.conf

echo "session    required    /lib/security/pam_limits.so" >> /etc/pam.d/login

# 删除多余账号和组

userdel adm
userdel lp
userdel sync
userdel shutdown
userdel halt
userdel news
userdel uucp
userdel operator
userdel games
userdel gopher
userdel ftp

groupdel adm
groupdel lp
groupdel news
groupdel uucp
groupdel games
groupdel dip
groupdel pppusers



# 锁住密码
passwd -l xfs
passwd -l nscd
passwd -l dbus
passwd -l vcsa
passwd -l nobody
passwd -l avahi
passwd -l haldaemon
passwd -l mailnull
passwd -l pcap
passwd -l mail



# 停止服务
SERVICES="acpid apmd atd autofs avahi-daemon bluetooth cpuspeed cups firstboot gpm haldaemon hidd hplip ip6tables isdn lm_sensors netfs nfslock pcscd portmap rpcgssd rpcidmapd sendmail xfs yum-updatesd"
for service in $SERVICES
do
    /sbin/chkconfig $service off
    /sbin/service $service stop
done