#!/bin/bash
#
# @author zhangqiang<komazhang@foxmail.com>
# @date   2015.06.25 13:58:36
#
#

#remove the read command backspace exception
stty erase '^H'

if [ ! $SCRIPT_PATH ]; then
    echo -e "##-------------------------------\n"
    echo " please use it correct "
    echo -e "\n##-------------------------------"
    exit 1
fi

#check if there has another nginx run
isHave=$( ps -el | grep nginx )
if [ "$isHave" != "" ];then
    read -p " there has another nginx running, if u want to kill it and continue to install, please input [yes]: " isY
    if [ "$isY" == "yes" ];then
        pkill -9 nginx
    else
        echo -e $TOP_MARK
        echo "  nginx install stoped  "
        echo -e $BOTTOM_MARK
        exit 1
    fi
fi
rm -rf "$NGINX_INSTALL_PATH"

#chose the install item
echo -e $TOP_MARK
echo " install nginx   --- 1 "
echo " install tengine --- 2 "
echo -e $BOTTOM_MARK
read -p "  please select whitch package u want to install: " idxItem

#show the list of tar package
if [ "$idxItem" -eq "1" ];then
    srcpackagedir="$SRC_NGINX_PATH"
elif [ "$idxItem" -eq "2" ];then
    srcpackagedir="$SRC_TENGINE_PATH"
fi

cd $srcpackagedir

if [ "$idxItem" -eq "1" ];then
    tarNum=$( ls nginx*.tar* | wc -l )
elif [ "$idxItem" -eq "2" ];then
    tarNum=$( ls tengine*.tar* | wc -l )
fi

if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    if [ "$idxItem" -eq "1" ];then
        tname=$( ls nginx*.tar* | sed -n "${i}p" )
    elif [ "$idxItem" -eq "2" ];then
        tname=$( ls tengine*.tar* | sed -n "${i}p" )
    fi
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch nginx version u want to install:  " vidx

if [ "$vidx" -gt "$tarNum" ];then
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

if [ "$idxItem" -eq "1" ];then
    nginx_tarname=$( ls nginx*.tar* | sed -n "${vidx}p" )
elif [ "$idxItem" -eq "2" ];then
    nginx_tarname=$( ls tengine*.tar* | sed -n "${vidx}p" )
fi
nginx_sourcedir=${nginx_tarname%.tar*}

if [ ! -f "$nginx_tarname" ];then
    echo -e $TOP_MARK
    echo " the ${nginx_tarname} is not exists in ${srcpackagedir}"
    echo -e $BOTTOM_MARK
    exit 1
fi

#print the begin message
echo -e $TOP_MARK
echo "  nginx begin to install "
echo -e $BOTTOM_MARK
sleep 2

#install the depend package zlib,openssl,pcre
cd $SRC_LIB_PATH
tarname="zlib-1.2.8.tar.gz"
zlib_sourcedir="zlib-1.2.8"
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $SRC_LIB_PATH"
    echo -e $BOTTOM_MARK
    exit 1
fi
rm -rf "$zlib_sourcedir"
tar -xzvf "$tarname"
cd "$zlib_sourcedir"
./configure --prefix="$INSTALL_PATH"/zlib
if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

tarname="openssl-1.0.1j.tar.gz"
openssl_sourcedir="openssl-1.0.1j"
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $SRC_LIB_PATH"
    echo -e $BOTTOM_MARK
    exit 1
fi
rm -rf "$openssl_sourcedir"
tar -xzvf "$tarname"
cd "$openssl_sourcedir"
./configure --prefix="$INSTALL_PATH"/openssl
if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

tarname="pcre-8.34.tar.gz"
pcre_sourcedir="pcre-8.34"
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $SRC_LIB_PATH"
    echo -e $BOTTOM_MARK
    exit 1
fi
hasPcre=$( ll "$INSTALL_PATH" | grep pcre )
if [ ! "$hasPcre" -eq "" ];then
    rm -rf "$INSTALL_PATH"/pcre
fi
rm -rf "$pcre_sourcedir"
tar -xzvf "$tarname"
cd "$pcre_sourcedir"
./configure --prefix="$INSTALL_PATH"/pcre
if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

#change dir to the nginx/tengine src dir
cd "$srcpackagedir"
tarname="$nginx_tarname"
sourcedir="$nginx_sourcedir"

#begin to install nginx/tengine
rm -rf "$sourcedir"
tar -xzvf "$tarname"
cd "$sourcedir"

./configure --prefix="$NGINX_INSTALL_PATH" \
--sbin-path="$NGINX_INSTALL_PATH"/sbin/nginx \
--conf-path="$NGINX_INSTALL_PATH"/conf/nginx.conf \
--pid-path="$NGINX_INSTALL_PATH"/logs/nginx.pid \
--with-http_ssl_module \
--with-pcre="$SRC_LIB_PATH"/"$pcre_sourcedir" \
--with-zlib="$SRC_LIB_PATH"/"$zlib_sourcedir" \
--with-openssl="$SRC_LIB_PATH"/"$openssl_sourcedir"

if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

#check if insatll ok
if [ ! $? -eq 0 ];then
    echo -e $TOP_MARK
    echo " there is an error accoured,please check!!! "
    echo -e $BOTTOM_MAKR
    exit 1
fi

#add nginx into chkconfig
rm -rf /etc/init.d/nginx
cp "$SCRIPT_LNMP_PATH"/nginx /etc/init.d/nginx
sed -i "s#NGINX_EXEC=''#NGINX_EXEC=\"${NGINX_INSTALL_PATH}/sbin/nginx\"#g" /etc/init.d/nginx
sed -i "s#NGINX_PID=''#NGINX_PID=\"${NGINX_INSTALL_PATH}/logs/nginx.pid\"#g" /etc/init.d/nginx

chmod aou+x /etc/init.d/nginx
chkconfig nginx on

#start the nginx
service nginx start
if [ $? -eq 0 ]; then
    echo -e $TOP_MARK >> "$NGINX_INSTALL_LOG"
    echo " nginx install path is: ${NGINX_INSTALL_PATH}" >> "$NGINX_INSTALL_LOG"
    echo " nginx configure path is: ${NGINX_INSTALL_PATH}/conf/nginx.conf" >> "$NGINX_INSTALL_LOG" 
    echo " nginx had add into the chkconfig, u can use the command: service nginx start/stop/restart to control it " >> "$NGINX_INSTALL_LOG" 
    echo " or u can use the command: kill -HUP/-QUIT/-TERM \`cat ${NGINX_INSTALL_PATH}/logs/nginx.pid\` to control it " >> "$NGINX_INSTALL_LOG" 
    echo -e $BR >> "$NGINX_INSTALL_LOG"
    echo "   nginx installed successed. Bye ^_^   " >> "$NGINX_INSTALL_LOG"
    echo -e $BOTTOM_MARK >> "$NGINX_INSTALL_LOG"
else
    echo -e $TOP_MARK
    echo "    nginx start faild "
    echo " nginx had add into the chkconfig, u can use the command: service nginx start/stop/restart to control it " >> "$NGINX_INSTALL_LOG" 
    echo " or u can use the command: kill -HUP/-QUIT/-TERM \`cat ${NGINX_INSTALL_PATH}/logs/nginx.pid\` to control it " >> "$NGINX_INSTALL_LOG" 
    echo -e $BOTTOM_MARK
fi

#print the success message
echo -e $TOP_MARK
echo -e "$BR             nginx installed successed  ^_^   "
echo -e "$BR   now u can use this link: http://127.0.0.1 to check it  "
echo -e $BOTTOM_MARK
exit 0

##-------------------------------------------EOF
