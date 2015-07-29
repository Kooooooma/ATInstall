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

#begin to install
cd "$SRC_PHP_PATH"

#chose the php version
tarNum=$( ls php*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls php*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch php version u want to install:  " vidx

if [ "$vidx" -gt "$tarNum" ];then
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

tarname=$( ls php*.tar* | sed -n "${vidx}p" )
sourcedir=${tarname%.tar*}
if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $SRC_PHP_PATH"
    echo -e $BOTTOM_MARK
    exit 1
fi

rm -rf "$PHP_INSTALL_PATH"

#print begin message
echo -e $TOP_MARK
echo "  php begin to install  "
echo -e $BOTTOM_MARK
sleep 2

rm -rf "$sourcedir"
tar -xzvf "$tarname"
cd "$sourcedir"

./configure --prefix="$PHP_INSTALL_PATH" \
--enable-fpm \
--with-mysql \
--with-mysqli \
--enable-pdo \
--with-pdo-mysql \
--enable-sockets \
--enable-mbstring \
--with-curl \
--enable-inline-optimization \
--with-bz2 \
--with-zlib \
--enable-sysvsem \
--enable-sysvshm \
--enable-pcntl \
--enable-mbregex \
--with-mhash \
--enable-zip \
--with-pcre-regex \
--with-gd \
--enable-gd-native-ttf \
--with-freetype-dir \
--with-zlib-dir \
--with-jpeg-dir

if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

#create the config file and check is there has an error
cp php.ini-development "$PHP_INSTALL_PATH"/lib/php.ini
cp "$PHP_INSTALL_PATH"/etc/php-fpm.conf.default "$PHP_INSTALL_PATH"/etc/php-fpm.conf
if [ ! $? -eq 0 ];then
    echo -e $TOP_MARK
    echo " there is an error occured. please check it!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

#change the php-fpm.conf
sed -i 's/;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/g' "$PHP_INSTALL_PATH"/etc/php-fpm.conf

#start the php-fpm
isHave=$( ps -el | grep php-fpm )
if [ "$isHave" != "" ];then
    pkill -9 php-fpm
fi

#add php-fpm into chkconfig
rm -rf /etc/init.d/php-fpm
cp "$SCRIPT_LNMP_PATH"/php-fpm /etc/init.d/php-fpm
sed -i "s#FPM_EXEC=''#FPM_EXEC=\"${PHP_INSTALL_PATH}/sbin/php-fpm\"#g" /etc/init.d/php-fpm
sed -i "s#FPM_PID=''#FPM_PID=\"${PHP_INSTALL_PATH}/var/run/php-fpm.pid\"#g" /etc/init.d/php-fpm

chmod aou+x /etc/init.d/php-fpm
chkconfig php-fpm on

service php-fpm start
if [ ! $? -eq 0 ];then
    echo -e $TOP_MARK
    echo " php-fpm start faild, please check!!! "
    echo -e $BOTTOM_MARK
fi

#write install log
echo -e $TOP_MARK >> "$PHP_INSTALL_LOG"
echo " php install path is: $PHP_INSTALL_PATH" >> "$PHP_INSTALL_LOG"
echo " php configure path is: ${PHP_INSTALL_PATH}/lib/php.ini" >> "$PHP_INSTALL_LOG" 
echo " php-fpm configure path is: ${PHP_INSTALL_PATH}/etc/php-fpm.conf" >> "$PHP_INSTALL_LOG" 
echo " php-fpm had add into the chkconfig, u can use the command: service php-fpm start/stop/restart to control it " >> "$PHP_INSTALL_LOG" 
echo " or u can use the command: ${PHP_INSTALL_PATH}/sbin/php-fpm to start the php-fpm" >> "$PHP_INSTALL_LOG" 
echo " or u can use the command: kill -INT/-USR2 \`cat ${PHP_INSTALL_PATH}/var/run/php-fpm.pid\` to control the php-fpm" >> "$PHP_INSTALL_LOG" 
echo -e $BR >> "$PHP_INSTALL_LOG"
echo "   php installed successed. Bye ^_^   " >> "$PHP_INSTALL_LOG"
echo -e $BOTTOM_MARK >> "$PHP_INSTALL_LOG"

#print the success message
echo -e $TOP_MARK
echo -e "$BR   php installed successed  ^_^   "
echo " php-fpm had add into the chkconfig, u can use the command: service php-fpm start/stop/restart to control it " 
echo -e "$BR   u need to restart ur nginx server  ^_^   "
echo -e $BOTTOM_MARK
exit 0

##-----------------------------------------------EOF
