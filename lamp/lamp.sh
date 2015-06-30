#!/bin/bash
#
# @author zhangqiang<komazhang@foxmail.com>
# @date   2015.06.25 13:58:36
#

#remove the read command backspace exception
stty erase '^H'

if [ ! $SCRIPT_PATH ]; then
    echo -e "##-------------------------------\n"
    echo " please use it correct "
    echo -e "\n##-------------------------------"
    exit 1
fi

#define the install log file name
MYSQL_INSTALL_LOG="$LOG_FILE_PATH"/mysql.install.log
HTTPD_INSTALL_LOG="$LOG_FILE_PATH"/httpd.install.log
PHP_INSTALL_LOG="$LOG_FILE_PATH"/php.install.log

export MYSQL_INSTALL_LOG
export HTTPD_INSTALL_LOG
export PHP_INSTALL_LOG

echo -e $TOP_MARK
echo " only install mysql  --- 1 "
echo " only install httpd  --- 2 "
echo " only install php    --- 3 "
echo " install all of them --- 4 "
echo -e $BOTTOM_MARK

read -p " please select whitch item u want to install:  " itemIdx
case $itemIdx in
    1)
        echo > "$MYSQL_INSTALL_LOG"
        echo -e $BR
        read -p "please input the mysql install dir: " MYSQL_INSTALL_PATH
        
        MYSQL_INSTALL_PATH="$INSTALL_PATH"/"$MYSQL_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the mysql install path is: "
        echo " mysql  --- "$MYSQL_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $MYSQL_INSTALL_LOG "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export MYSQL_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi

        "$SCRIPT_LAMP_PATH"/mysql.sh
    ;;
    2)
        echo > "$HTTPD_INSTALL_LOG"
        echo -e $BR
        read -p "please input the apache install dir: " HTTPD_INSTALL_PATH
        
        HTTPD_INSTALL_PATH="$INSTALL_PATH"/"$HTTPD_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the apache install path is: "
        echo " apache --- "$HTTPD_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $HTTPD_INSTALL_LOG "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export HTTPD_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi
        "$SCRIPT_LAMP_PATH"/apache.sh
    ;;
    3)
        echo > "$PHP_INSTALL_LOG"
        echo -e $BR
        read -p "please input the php install dir: " PHP_INSTALL_PATH
        read -p "please input the apache install dir: " HTTPD_INSTALL_PATH
        
        PHP_INSTALL_PATH="$INSTALL_PATH"/"$PHP_INSTALL_PATH"
        HTTPD_INSTALL_PATH="$INSTALL_PATH"/"$HTTPD_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the php,apache install path is: "
        echo " php    --- "$PHP_INSTALL_PATH
        echo " apache --- "$HTTPD_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $PHP_INSTALL_LOG "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export PHP_INSTALL_PATH
            export HTTPD_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi
        "$SCRIPT_LAMP_PATH"/php.sh
    ;;
    4)
        #empty the insall log
        echo > "$MYSQL_INSTALL_LOG"
        echo > "$HTTPD_INSTALL_LOG"
        echo > "$PHP_INSTALL_LOG"
        echo -e $BR
        read -p "please input the apache install dir: " HTTPD_INSTALL_PATH
        read -p "please input the mysql install dir: " MYSQL_INSTALL_PATH
        read -p "please input the php install dir: " PHP_INSTALL_PATH
        
        HTTPD_INSTALL_PATH="$INSTALL_PATH"/"$HTTPD_INSTALL_PATH"
        MYSQL_INSTALL_PATH="$INSTALL_PATH"/"$MYSQL_INSTALL_PATH"
        PHP_INSTALL_PATH="$INSTALL_PATH"/"$PHP_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the mysql,php,apache install path is: "
        echo " mysql  --- "$MYSQL_INSTALL_PATH
        echo " apache --- "$HTTPD_INSTALL_PATH
        echo " php    --- "$PHP_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $LOG_FILE_PATH "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export HTTPD_INSTALL_PATH
            export MYSQL_INSTALL_PATH
            export PHP_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi
        "$SCRIPT_LAMP_PATH"/mysql.sh
        if [ $? -eq 0 ];then
            "$SCRIPT_LAMP_PATH"/apache.sh
            if [ $? -eq 0 ];then
                "$SCRIPT_LAMP_PATH"/php.sh
                if [ $? -eq 0 ];then
                    httpdStOk=$( ps -el|grep httpd )
                    mysqlStOk=$( ps -el|grep mysql )
                    echo -e $TOP_MARK
                    echo " LAMP install successed. "
                    if [ "$httpdStOk" -eq "" ];then
                        echo " apache start           [Faild] "
                    else
                        echo " apache start           [OK] "
                    fi
                    if [ "$mysqlStOk" -eq "" ];then
                        echo " mysql start            [Faild] "
                    else
                        echo " mysql start            [OK] "
                    fi
                    echo -e $BOTTOM_MARK
                fi
            fi
        fi
    ;;
    *)
        echo $TOP_MARK
        echo " u are wrong "
        echo $BOTTOM_MARK
    ;;
esac
exit 0

##----------------EOF
