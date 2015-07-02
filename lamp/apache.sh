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

#if the system is centos, we need to delete the default httpd rpm package
if [ "$ifcentos" != "" ]; then
    echo -e " del the default httpd rpm package \n"
fi

#check if there has another httpd run
isHave=$( ps -el | grep httpd )
if [ "$isHave" != "" ];then
    read -p " there has another httpd running, if u want to kill it and continue to install, please input [yes]: " isY
    if [ "$isY" == "yes" ];then
        pkill -9 httpd
    else
        echo -e $TOP_MARK
        echo "  apache install stoped  "
        echo -e $BOTTOM_MARK
        exit 1
    fi
fi
rm -rf "$HTTPD_INSTALL_PATH"
rm -rf /etc/init.d/httpd

#chose the apache version
cd $SRC_HTTPD_PATH
tarNum=$( ls httpd*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls httpd*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch httpd version u want to install:  " vidx

if [ "$vidx" -gt "$tarNum" ];then
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

httpd_tarname=$( ls httpd*.tar* | sed -n "${vidx}p" )
httpd_sourcedir=${httpd_tarname%.tar*}

#set the httpd listen port
port="port"
echo -e $TOP_MARK
until [[ "$port" =~ ^[1-9][0-9]+$ ]]
do
    read -p " please input the httpd listen port number: " port
    port="$port"
    echo ""
done
echo -e "$BR"
echo " the httpd listen port is: "$port
echo -e $BOTTOM_MARK

#install the depend package apr,apr-util,pcre
apr_path="$SRC_LIB_PATH"/apr
if [ ! -d ${apr_path} ];then
    mkdir $apr_path
fi
cd $apr_path

tarNum=$( ls apr*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no apr package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls apr*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch apr version u want to install:  " vidx

tarname=$( ls apr*.tar* | sed -n "${vidx}p" )
apr_sourcedir=${tarname%.tar*}
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $apr_path"
    echo -e $BOTTOM_MARK
    exit 1
fi
rm -rf "$apr_sourcedir"
tar -xzvf "$tarname"
cd "$apr_sourcedir"
./configure --prefix="$INSTALL_PATH"/apr
if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

##-------------------------------------------------------
apr_util_path="$SRC_LIB_PATH"/apr-util
if [ ! -d ${apr_util_path} ];then
    mkdir $apr_util_path
fi
cd $apr_util_path

tarNum=$( ls apr-util*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no apr-util package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls apr-util*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch apr-util version u want to install:  " vidx

tarname=$( ls apr-util*.tar* | sed -n "${vidx}p" )
apr_util_sourcedir=${tarname%.tar*}
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $apr_util_path"
    echo -e $BOTTOM_MARK
    exit 1
fi
rm -rf "$apr_util_sourcedir"
tar -xzvf "$tarname"
cd "$apr_util_sourcedir"
./configure --prefix="$INSTALL_PATH"/apr-util --with-apr="$INSTALL_PATH"/apr
if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

##--------------------------------------------------------
pcre_path="$SRC_LIB_PATH"/pcre
if [ ! -d ${pcre_path} ];then
    mkdir $pcre_path
fi
cd $pcre_path

tarNum=$( ls pcre*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no pcre package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls pcre*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch pcre version u want to install:  " vidx

tarname=$( ls pcre*.tar* | sed -n "${vidx}p" )
pcre_sourcedir=${tarname%.tar*}
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $pcre_path"
    echo -e $BOTTOM_MARK
    exit 1
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

#print the begin message
echo -e $TOP_MARK
echo "  apache begin to install "
echo -e $BOTTOM_MARK
sleep 2

#change dir to the httpd src dir
cd $SRC_HTTPD_PATH
tarname="$httpd_tarname"
sourcedir="$httpd_sourcedir"
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $SRC_HTTPD_PATH"
    echo -e $BOTTOM_MARK
    exit 1
fi

#begin to install apache
rm -rf "$sourcedir"
tar -xzvf "$tarname"
cd "$sourcedir"

./configure --prefix="$HTTPD_INSTALL_PATH" \
--enable-mods-shared=all \
--enable-so \
--enable-rewrite \
--with-apr="$INSTALL_PATH"/apr \
--with-apr-util="$INSTALL_PATH"/apr-util \
--with-pcre

if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

#add httpd into chkconfig list
echo "#!/bin/bash" > /etc/init.d/httpd
echo "#chkconfig:2345 85 15" >> /etc/init.d/httpd
echo "#" >> /etc/init.d/httpd
grep -v "#" "$HTTPD_INSTALL_PATH"/bin/apachectl >> /etc/init.d/httpd
chmod aou+x /etc/init.d/httpd
chkconfig httpd on

#change the apache conf
sed -i "s/Listen 80/Listen ${port}/g" "$HTTPD_INSTALL_PATH"/conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName localhost/g' "$HTTPD_INSTALL_PATH"/conf/httpd.conf

#start the httpd
service httpd start
if [ $? -eq 0 ]; then
    echo -e $TOP_MARK >> "$HTTPD_INSTALL_LOG"
    echo " apache install path is: ${HTTPD_INSTALL_PATH}" >> "$HTTPD_INSTALL_LOG"
    echo " apache configure path is: ${HTTPD_INSTALL_PATH}/conf/httpd.conf" >> "$HTTPD_INSTALL_LOG" 
    echo " apache listen port is: $port" >> "$HTTPD_INSTALL_LOG" 
    echo " apache had add into the chkconfig, u can use the command: service httpd start/stop/restart to control it " >> "$HTTPD_INSTALL_LOG" 
    echo -e $BR >> "$HTTPD_INSTALL_LOG"
    echo "   apache installed successed. Bye ^_^   " >> "$HTTPD_INSTALL_LOG"
    echo -e $BOTTOM_MARK >> "$HTTPD_INSTALL_LOG"
else
    echo -e $TOP_MARK
    echo "    apache start faild "
    echo " u can use the command: service httpd start/stop/restart to control it  "
    echo -e $BOTTOM_MARK
fi

#print the success message
echo -e $TOP_MARK
echo -e "$BR             apache installed successed  ^_^   "
echo -e "$BR   now u can use this link: http://127.0.0.1:${port} to check it  "
echo -e $BOTTOM_MARK
exit 0

##-------------------------------------------EOF
