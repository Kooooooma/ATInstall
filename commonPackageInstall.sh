#!/bin/bash
#
# @author zhangqiang<komazhang@foxmail.com>
# @date   2015.06.25 13:58:36
#
# this file is used for install the common package 
#

#remove the read command backspace exception
stty erase '^H'

if [ ! $UID -eq 0 ]; then
    echo -e "##------------------------------------\n"
    echo " this file need the root permission, please check! "
    echo -e "\n##------------------------------------"
    exit 1
fi

yum -y install gcc automake autoconf libtool make \
cmake gcc-c++ ncurses ncurses-devel glibc zlib-devel openssl openssl-devel libxslt-devel \
libxml2 libxml2-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel \
curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel

