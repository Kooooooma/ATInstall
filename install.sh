#!/bin/bash
#
# @author zhangqiang<komazhang@foxmail.com>
# @date   2015.06.25 11:22:36
#
# this is a script for install the LAMP or LNMP
# u can change it if u need
#

#remove the read command backspace exception
stty erase '^H'

#define the echo mark
LINE="##---------------------------------------------------------------##"
BR="\n"
TOP_MARK="$LINE""$BR"
BOTTOM_MARK="$BR""$LINE"

export TOP_MARK
export BOTTOM_MARK
export LINE
export BR

#system check
ifcentos=$( cat /proc/version | grep centos )
declare -i ifcheck=0

export ifcentos

if [ "$ifcentos" == "" ]; then
    echo -e $TOP_MARK
    echo "WARRING: ur system is not the CentOS, this script is based on CentOS.Please Think..."
    isY="no"
    read -p "If u want to continue please input [yes] or input [no] to exit : " isY
    if [ "$isY" == "yes" ]; then
        ifcheck=1
    else
        echo "thanks for ur test.Bye ^_^"
        echo -e $BOTTOM_MARK
        exit 0
    fi
    echo -e $BOTTOM_MARK
else
    ifcheck=1
fi

if [ $ifcheck == 0 ]; then
    echo -e $TOP_MARK
    echo "thanks for ur test.Bye ^_^"
    echo -e $BOTTOM_MARK
    exit 0
fi

#check permission
if [ ! $UID -eq 0 ]; then
    echo -e $TOP_MARK
    echo " this is need the root permission, please check and exec it again. "
    echo -e $BOTTOM_MARK
    exit 1
fi

#install the common package
isY="no"
echo -e $TOP_MARK
read -p " run to install the common package [yes] or [no]: " isY
if [ "$isY" == "yes" ];then
    commonPackageInstall.sh
fi

#define some const
CPU_NUM=$( cat /proc/cpuinfo | grep processor | wc -l )
OS_NAME=$( uname -m )
SCRIPT_PATH=$( pwd )

INSTALL_PATH="/usr/local"

SRC_BASE_PATH="$SCRIPT_PATH"/src
SRC_PHP_PATH="$SCRIPT_PATH"/src/php
SRC_NGINX_PATH="$SCRIPT_PATH"/src/nginx
SRC_TENGINE_PATH="$SCRIPT_PATH"/src/tengine
SRC_HTTPD_PATH="$SCRIPT_PATH"/src/httpd
SRC_MYSQL_PATH="$SCRIPT_PATH"/src/mysql
SRC_LIB_PATH="$SCRIPT_PATH"/src/lib
SRC_REDIS_PATH="$SCRIPT_PATH"/src/redis
SRC_MEMCACHED_PATH="$SCRIPT_PATH"/src/memcached

SCRIPT_LAMP_PATH="$SCRIPT_PATH"/lamp
SCRIPT_LAMP_FILE="$SCRIPT_LAMP_PATH"/lamp.sh
SCRIPT_LNMP_PATH="$SCRIPT_PATH"/lnmp
SCRIPT_LNMP_FILE="$SCRIPT_LNMP_PATH"/lnmp.sh
SCRIPT_EXT_PATH="$SCRIPT_PATH"/extension
SCRIPT_EXT_FILE="$SCRIPT_EXT_PATH"/ext.sh
SCRIPT_SPHINX_PATH="$SCRIPT_PATH"/sphinx
SCRIPT_SPHINX_FILE="$SCRIPT_SPHINX_PATH"/sphinx.sh
SCRIPT_NOSQL_PATH="$SCRIPT_PATH"/nosql
SCRIPT_NOSQL_FILE="$SCRIPT_NOSQL_PATH"/nosql.sh

LOG_FILE_PATH="$SCRIPT_PATH"/log

export SCRIPT_PATH
export CPU_NUM
export OS_NAME
export SRC_BASE_PATH
export SRC_PHP_PATH
export SRC_NGINX_PATH
export SRC_TENGINE_PATH
export SRC_HTTPD_PATH
export SRC_MYSQL_PATH
export SRC_LIB_PATH
export SRC_REDIS_PATH
export SRC_MEMCACHED_PATH
export SCRIPT_LAMP_FILE
export SCRIPT_LAMP_PATH
export SCRIPT_LNMP_FILE
export SCRIPT_LNMP_PATH
export SCRIPT_EXT_FILE
export SCRIPT_EXT_PATH
export SCRIPT_SPHINX_FILE
export SCRIPT_SPHINX_PATH
export SCRIPT_NOSQL_FILE
export SCRIPT_NOSQL_PATH
export LOG_FILE_PATH

declare -i DEFAULT_MODE=1
declare -i CUSTOM_MODE=2

#set the install mode
echo -e $TOP_MARK
echo " default mode --- ${DEFAULT_MODE} "
echo " custom mode  --- ${CUSTOM_MODE} "
echo -e $BR
echo " there has two mode for ur chose about the install path "
echo " in default mode the base install path and the package install path u could'n to change it again"
echo " in custom mode the base install path and the package install path u need to set it for urself"
echo -e $BOTTOM_MARK
declare -i mode=0
read -p " please select the mode u want: " mode

if [ ${mode} -eq ${DEFAULT_MODE} ]; then
    INSTALL_PATH="/usr/local"
elif [ ${mode} -eq ${CUSTOM_MODE} ]; then
    echo -e $TOP_MARK
    read -p " u chose the custom mode, please input the base install path(do not end with '/'): " base_install_path
    if [ "$base_install_path" == "" ];then
        echo -e $TOP_MARK
        echo " please input a right path string "
        echo -e $BOTTOM_MARK
        exit 1
    fi
    if [ ! -d "$base_install_path" ];then
        echo -e $BR
        read -p " the directory is not exists, if u want to creat it please input [yes] or [no]: " isY
        if [ "$isY" == "yes" ];then
            mkdir "$base_install_path"
            INSTALL_PATH="$base_install_path"
        else
            echo -e $TOP_MARK
            echo " input a wrong install dir "
            echo -e $BOTTOM_MARK
            exit 1
        fi
    fi
else
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

INSTALL_MODE=$mode
export INSTALL_MODE
export INSTALL_PATH
export DEFAULT_MODE
export CUSTOM_MODE

echo -e $TOP_MARK
echo " install LAMP      --- please input 1"
echo " install LNMP      --- please input 2"
echo " install NoSQL     --- please input 3"
echo " install Sphinx    --- please input 4"
echo " install extension --- please input 5"
echo -e $BR
echo "     Notice! the install base path is [ $INSTALL_PATH ] "
echo -e $BOTTOM_MARK

declare -i itemIdx=0
read -p "Please select the item whitch u want to exec: " itemIdx

case $itemIdx in
    1)
        $SCRIPT_LAMP_FILE
    ;;
    2)
        $SCRIPT_LNMP_FILE
    ;;
    3)
        $SCRIPT_NOSQL_FILE
    ;;
    4)
        read -p "please input the sphinx install dir: " SPHINX_INSTALL_PATH

        echo -e $TOP_MARK
        echo " the sphinx install path is: "
        echo " sphinx  --- "$SPHINX_INSTALL_PATH
        echo -e $BOTTOM_MARK

        SPHINX_INSTALL_PATH="$INSTALL_PATH"/"$SPHINX_INSTALL_PATH"
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export SPHINX_INSTALL_PATH
            $SCRIPT_SPHINX_FILE
        else
            echo " exit... "
            exit 0
        fi
    ;;
    5)
        $SCRIPT_EXT_FILE
    ;;
    *)
        echo -e $TOP_MARK
        echo " u are wrong. Bye"
        echo -e $BOTTOM_MARK
    ;;
esac
exit 0

##--------------EOF
