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
--with-apxs2="$HTTPD_INSTALL_PATH"/bin/apxs \
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
--with-jpeg-dir

if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install

#create the config file and check is there has an error
cp php.ini-development "$PHP_INSTALL_PATH"/lib/php.ini
if [ ! $? -eq 0 ];then
    echo -e $TOP_MARK
    echo " there is an error occured. please check it!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

#config the httpd.conf
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' "$HTTPD_INSTALL_PATH"/conf/httpd.conf
cat >> "$HTTPD_INSTALL_PATH"/conf/httpd.conf <<EOF
<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
EOF

#write install log
echo -e $TOP_MARK >> "$PHP_INSTALL_LOG"
echo " php install path is: $PHP_INSTALL_PATH" >> "$PHP_INSTALL_LOG"
echo " php configure path is: ${PHP_INSTALL_PATH}/lib/php.ini" >> "$PHP_INSTALL_LOG" 
echo -e $BR >> "$PHP_INSTALL_LOG"
echo "   php installed successed. Bye ^_^   " >> "$PHP_INSTALL_LOG"
echo -e $BOTTOM_MARK >> "$PHP_INSTALL_LOG"

#print the success message
echo -e $TOP_MARK
echo -e "$BR   php installed successed  ^_^   "
echo -e "$BR   u need to restart ur httpd server  ^_^   "
echo -e $BOTTOM_MARK
exit 0

##-----------------------------------------------EOF
