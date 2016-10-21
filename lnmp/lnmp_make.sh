#!/bin/bash

. include/var.sh
. include/common.sh
. include/php.sh
. include/mysql.sh
. include/nginx.sh
. include/php.sh
. include/end.sh


Disable_Selinux

Disable_Firewalld

System_Update

RemoveAMP

Set_Timezone

InstallNTP

Dependent

Install_MySQL_56

Install_Nginx_18

Install_PHP_56

END
