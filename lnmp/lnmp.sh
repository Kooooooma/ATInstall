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
NGINX_INSTALL_LOG="$LOG_FILE_PATH"/nginx.install.log
PHP_INSTALL_LOG="$LOG_FILE_PATH"/php.install.log

export MYSQL_INSTALL_LOG
export NGINX_INSTALL_LOG
export PHP_INSTALL_LOG

echo -e $TOP_MARK
echo " only install mysql  --- 1 "
echo " only install nginx  --- 2 "
echo " only install php    --- 3 "
echo " install all of them --- 4 "
echo -e $BOTTOM_MARK

read -p " please select whitch item u want to install:  " itemIdx
case $itemIdx in
    1)
        echo > "$MYSQL_INSTALL_LOG"

        if [ ${INSTALL_MODE} -eq ${CUSTOM_MODE} ];then
            echo -e $BR
            read -p "please input the mysql install dir: " MYSQL_INSTALL_PATH
        else
            MYSQL_INSTALL_PATH="mysql"
        fi
        
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

        "$SCRIPT_LNMP_PATH"/mysql.sh
    ;;
    2)
        echo > "$NGINX_INSTALL_LOG"

        #chose the install item
        echo -e $TOP_MARK
        echo " install nginx   --- 1 "
        echo " install tengine --- 2 "
        echo -e $BOTTOM_MARK
        read -p "  please select whitch package u want to install: " idxItem
        
        if [ "$idxItem" -eq 1 ];then
            NGINX_TYPE=1
        elif [ "$idxItem" -eq 2 ];then
            NGINX_TYPE=2
        else
            echo -e $TOP_MARK
            echo " please input a right num "
            echo -e $BOTTOM_MARK
            exit 1
        fi

        if [ ${INSTALL_MODE} -eq ${CUSTOM_MODE} ];then
            echo -e $BR
            read -p "please input the nginx install dir: " NGINX_INSTALL_PATH
        else
            if [ ${NGINX_TYPE} -eq 1 ];then
                NGINX_INSTALL_PATH="nginx"
            elif [ ${NGINX_TYPE} -eq 2 ];then
                NGINX_INSTALL_PATH="tengine"
            fi
        fi
        export NGINX_TYPE
        
        NGINX_INSTALL_PATH="$INSTALL_PATH"/"$NGINX_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the nginx install path is: "
        echo " nginx --- "$NGINX_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $NGINX_INSTALL_LOG "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export NGINX_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi
        "$SCRIPT_LNMP_PATH"/engineX.sh
    ;;
    3)
        echo > "$PHP_INSTALL_LOG"
        

        if [ ${INSTALL_MODE} -eq ${CUSTOM_MODE} ];then
            echo -e $BR
            read -p "please input the php install dir: " PHP_INSTALL_PATH
            read -p "please input the nginx install dir: " NGINX_INSTALL_PATH
        else
            #chose the install item
            echo -e $TOP_MARK
            echo " install nginx   --- 1 "
            echo " install tengine --- 2 "
            echo -e $BOTTOM_MARK
            read -p "  please select whitch nginx package u had already installed: " idxItem
        
            if [ "$idxItem" -eq 1 ];then
                NGINX_TYPE=1
            elif [ "$idxItem" -eq 2 ];then
                NGINX_TYPE=2
            else
                echo -e $TOP_MARK
                echo " please input a right num "
                echo -e $BOTTOM_MARK
                exit 1
            fi
            export NGINX_TYPE
            
            if [ ${NGINX_TYPE} -eq 1 ];then
                NGINX_INSTALL_PATH="nginx"
            elif [ ${NGINX_TYPE} -eq 2 ];then
                NGINX_INSTALL_PATH="tengine"
            fi
            PHP_INSTALL_PATH="php"
        fi
        
        PHP_INSTALL_PATH="$INSTALL_PATH"/"$PHP_INSTALL_PATH"
        NGINX_INSTALL_PATH="$INSTALL_PATH"/"$NGINX_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the php,nginx install path is: "
        echo " php    --- "$PHP_INSTALL_PATH
        echo " nginx --- "$NGINX_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $PHP_INSTALL_LOG "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export PHP_INSTALL_PATH
            export NGINX_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi
        "$SCRIPT_LNMP_PATH"/php.sh
    ;;
    4)
        #empty the insall log
        echo > "$MYSQL_INSTALL_LOG"
        echo > "$NGINX_INSTALL_LOG"
        echo > "$PHP_INSTALL_LOG"
        
        #chose the install item
        echo -e $TOP_MARK
        echo " install nginx   --- 1 "
        echo " install tengine --- 2 "
        echo -e $BOTTOM_MARK
        read -p "  please select whitch nginx package u want to install: " idxItem
        
        if [ "$idxItem" -eq 1 ];then
            NGINX_TYPE=1
        elif [ "$idxItem" -eq 2 ];then
            NGINX_TYPE=2
        else
            echo -e $TOP_MARK
            echo " please input a right num "
            echo -e $BOTTOM_MARK
            exit 1
        fi

        if [ ${INSTALL_MODE} -eq ${CUSTOM_MODE} ];then
            echo -e $BR
            read -p "please input the mysql install dir: " MYSQL_INSTALL_PATH
            read -p "please input the php install dir: " PHP_INSTALL_PATH
            read -p "please input the nginx install dir: " NGINX_INSTALL_PATH
        else
            if [ ${NGINX_TYPE} -eq 1 ];then
                NGINX_INSTALL_PATH="nginx"
            elif [ ${NGINX_TYPE} -eq 2 ];then
                NGINX_INSTALL_PATH="tengine"
            fi
            MYSQL_INSTALL_PATH="mysql"
            PHP_INSTALL_PATH="php"
        fi
        export NGINX_TYPE
        
        NGINX_INSTALL_PATH="$INSTALL_PATH"/"$NGINX_INSTALL_PATH"
        MYSQL_INSTALL_PATH="$INSTALL_PATH"/"$MYSQL_INSTALL_PATH"
        PHP_INSTALL_PATH="$INSTALL_PATH"/"$PHP_INSTALL_PATH"

        echo -e $BR
        echo -e $TOP_MARK
        echo " the mysql,php,nginx install path is: "
        echo " mysql  --- "$MYSQL_INSTALL_PATH
        echo " nginx --- "$NGINX_INSTALL_PATH
        echo " php    --- "$PHP_INSTALL_PATH
        echo -e "$BR Notice! If the install process has done, u can check the install log from: $LOG_FILE_PATH "
        echo -e $BOTTOM_MARK
        
        read -p "if u want to continue please input [yes] or [no] to exit: " isY
        if [ "$isY" == "yes" ]; then
            export MYSQL_INSTALL_PATH
            export NGINX_INSTALL_PATH
            export PHP_INSTALL_PATH
        else
            echo " exit... "
            exit 1
        fi
        "$SCRIPT_LNMP_PATH"/mysql.sh
        if [ $? -eq 0 ];then
            "$SCRIPT_LNMP_PATH"/engineX.sh
            if [ $? -eq 0 ];then
                "$SCRIPT_LNMP_PATH"/php.sh
                if [ $? -eq 0 ];then
                    nginxStOk=$( ps -el|grep nginx )
                    mysqlStOk=$( ps -el|grep mysql )
                    fpmStOk=$( ps -el|grep php-fpm )
                    echo -e $TOP_MARK
                    echo " LNMP install successed. "
                    if [ "$nginxStOk" -eq "" ];then
                        echo " nginx start        [Faild]  "
                    else
                        echo " nginx start        [OK] "
                    fi
                    if [ "$mysqlStOk" -eq "" ];then
                        echo " mysql start        [Faild]  "
                    else
                        echo " mysql start        [OK]  "
                    fi
                    if [ "$fpmStOk" -eq "" ];then
                        echo " php-fpm start      [Faild] "
                    else
                        echo " php-fpm start      [OK] "
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
