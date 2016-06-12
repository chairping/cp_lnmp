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