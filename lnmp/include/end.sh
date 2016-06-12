#!/bin/bash

End() {

  cp ${cur_dir}/tool/lnmp /etc/init.d/lnmp
  cp ${cur_dir}/tool/lnmp /usr/bin/lnmp

  chmod +x /etc/init.d/lnmp

  service lnmp start
}