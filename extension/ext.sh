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
echo " install nginx extension   --- 1 "
echo " install php extension     --- 2 "
echo " the extension source code dir is in ${SCRIPT_EXT_PATH} "
echo -e $BOTTOM_MARK

read -p " please select whitch item of extension u want to install:  " itemIdx

if [ "$itemIdx" -eq 1 ];then
    extpath="$SCRIPT_EXT_PATH"/extpackage/nginx
elif [ "$itemIdx" -eq 2 ];then
    extpath="$SCRIPT_EXT_PATH"/extpackage/php
else
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

pknum=$( ls "$extpath" | wc -l )
if [ "$pknum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there is no enable package for use. "
    echo -e $BOTTOM_MARK
    exit 1
fi

#change dir into the extpath
cd "$extpath"

#show the enable extpackage
echo -e $TOP_MARK
for (( i=1; i<=${pknum}; i++ ))
do
    pkname=$( ls "$extpath" | sed -n "${i}p" )
    echo " ${pkname} --- ${i} "
done
echo -e $BOTTOM_MARK
declare -i eidx=0
read -p " please select whitch extension u want to install: " eidx

if [ "$eidx" -eq 0 ] || [ "$eidx" -gt "$pknum" ];then
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

#set the right extdir and then use to install
extpkname=$( ls "$extpath" | sed -n "${eidx}p" )
isTarGz=${extpkname:0-7:7}
isTar=${extpkname:0-4:4}
if [ "$isTarGz" == ".tar.gz" ];then
    extdir=${extpkname%.tar*}
    rm -rf "$extdir"
    tar -xzvf "$extpkname"
elif [ "$isTar" == ".tar" ];then
    extdir=${extpkname%.tar*}
    rm -rf "$extdir"
    tar -xvf "$extpkname"
elif [ -d "$extpkname" ];then
    extdir="$extpkname"
else
    echo -e $TOP_MARK
    echo " the extension package is not a tar package or also it is not a directory "
    echo -e $BOTTOM_MARK
    exit 1
fi

#begin to install the extension

exit 0

##---------------------------------------------------EOF
