# cp_lnmp


该安装包的lnmp安装在/opt目录下　方便管理和迁。　


```
    Echo_Blue "[+] 注册mysql/lib 共享库"
    cat > /etc/ld.so.conf.d/lnmp.conf<<EOF
    /opt/lnmp/mysql/lib
EOF
    ldconfig -v
```


使用方法　./install.sh






　