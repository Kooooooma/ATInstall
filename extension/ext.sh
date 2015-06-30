#!/bin/bash
#
# @author zhangqiang<komazhang@foxmail.com>
# @date   2015.06.25 13:58:36
#
# this is the extension install script
# u have to change it to adapt to ur own env
#
#remove the read command backspace exception
stty erase '^H'

if [ ! $SCRIPT_PATH ]; then
    echo -e "##-------------------------------\n"
    echo " please use it correct "
    echo -e "\n##-------------------------------"
    exit 1
fi

echo -e $TOP_MARK
echo " for now, this script only can install the nginx and php extension. "
echo " install php extension   --- 1 "
echo " install nginx extension --- 2 "
echo " the extension source code dir is in ${SCRIPT_EXT_PATH} "
echo -e $BOTTOM_MARK

read -p " please select whitch item of extension u want to install:  " itemIdx

if [ "$itemIdx" -eq 1 ];
    extpath="$SCRIPT_EXT_PATH"/nginx
elif [ "$itemIdx" -eq 2 ];
    extpath="$SCRIPT_EXT_PATH"/php
else
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi



exit 0

##---------------------------------------------------EOF
