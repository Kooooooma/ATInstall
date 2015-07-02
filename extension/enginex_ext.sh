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

#get the nginx ecex file
if [ ${INSTALL_MODE} -eq ${CUSTOM_MODE} ];then
    echo -e $TOP_MARK
    read -p " please input the nginx exec file path: " nginx_exec_file
    if [ ! -f "$nginx_exec_file" ];then
        echo -e $TOP_MARK
        echo " this is not a enable file "
        echo -e $BOTTOM_MARK
        exit 1
    fi
else
    nginx_exec_file="$INSTALL_PATH"/nginx/sbin/nginx
fi
echo -e $TOP_MARK
echo " ur intalled nginx config information is: "
echo -e $BR
$nginx_exec_file -V
echo -e $BR
echo "  please check the config argument item, make sure that the pcre,zlib,openssl dir is exists"
echo "  if the config argument item has these three options."
echo "  if these dirs is not exists, when u restart ur nginx server after the extension install done there will be an error occurred!"
echo -e $BOTTOM_MARK

#get the config args
$nginx_exec_file -V 2> .tmp
tmp=$( cat .tmp | sed -n '5p' )
config_info=${tmp#configure arguments:* }
rm -rf .tmp

#check the extpath
extpath="$SRC_EXT_PATH"/nginx
if [ ! -d ${extpath} ];then
    mkdir $extpath
fi
pknum=$( ls "$extpath" | wc -l )
if [ "$pknum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there is no enable package for use. "
    echo -e $BOTTOM_MARK
    exit 1
fi

#chose the installed nginx version
cd "$SRC_NGINX_PATH"
tarNum=$( ls nginx*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no nginx source code package for use!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls nginx*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch nginx version u had installed:  " vidx

nginx_tarname=$( ls nginx*.tar* | sed -n "${vidx}p" )
if [ ! -f "$nginx_tarname" ];then
    echo -e $TOP_MARK
    echo " nginx tar ball is not enabled "
    echo -e $BOTTOM_MARK
    exit 1
fi
tar -xzvf "$nginx_tarname"
nginx_sourcedir="$SRC_NGINX_PATH"/${nginx_tarname%.tar*}

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

#set the right extdir and then use to install
extpkname=$( ls "$extpath" | sed -n "${eidx}p" )
isTarGz=${extpkname:0-7:7}
isTar=${extpkname:0-4:4}
if [ "$isTarGz" == ".tar.gz" ];then
    extdir="$extpath"/${extpkname%.tar*}
    rm -rf "$extdir"
    tar -xzvf "$extpkname"
elif [ "$isTar" == ".tar" ];then
    extdir="$extpath"/${extpkname%.tar*}
    rm -rf "$extdir"
    tar -xvf "$extpkname"
elif [ -d "$extpkname" ];then
    extdir="$extpath"/"$extpkname"
else
    echo -e $TOP_MARK
    echo " the extension package is not a tar package or also it is not a directory "
    echo -e $BOTTOM_MARK
    exit 1
fi

#echo $config_info
#echo $nginx_sourcedir
#echo $extdir
#begin to install the extension
echo -e $TOP_MARK
echo " nginx extension begin to install "
echo -e $BOTTOM_MARK
sleep 2

cd "$nginx_sourcedir"
./configure "$config_info" --add-module="$extdir"
if [ ! $? -eq 0 ];then
    echo -e $TOP_MARK
    echo " An error occurred, please check! "
    echo -e $BOTTOM_MARK
    exit 1
fi
if [ ${CPU_NUM} -gt 1 ];then
    make -j${CPU_NUM}
else
    make
fi

isHave=$( ps -el | grep nginx )
if [ "$isHave" != "" ];then
    pkill -9 nginx
fi

rm -rf /tmp/nginx.bak
cp "$nginx_exec_file" /tmp/nginx.bak
cp objs/nginx "$nginx_exec_file"
echo -e $TOP_MARK
echo "   nginx extension install successed "
echo "   u need to restart ur nginx server  "
echo " when u restart ur nginx server if there has an error occurred "
echo " u can run this command: cp /tmp/nginx.bak ${nginx_exec_file} and then restart the server, it will be ok!"
echo -e $BOTTOM_MARK
exit 0

##-------------------------------------------------------EOF
