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

#if the system is centos, we need to delete the default mysql rpm package
if [ "$ifcentos" != "" ]; then
    echo -e " del the default mysql rpm package \n"
fi

#check if there has another mysqld run
isHave=$( ps -el | grep mysqld )
if [ "$isHave" != "" ];then
    read -p " there has another mysqld running, if u want to kill it and continue to install, please input [yes]: " isY
    if [ "$isY" == "yes" ];then
        pkill -9 mysqld
    else
        echo -e $TOP_MARK
        echo "  mysql install stoped  "
        echo -e $BOTTOM_MARK
        exit 1 
    fi
fi
rm -rf /etc/my.cnf
rm -rf "$MYSQL_INSTALL_PATH"
rm -rf /etc/init.d/mysql

#change dir to the mysql src dir
cd $SRC_MYSQL_PATH

#chose the mysql version
tarNum=$( ls mysql*.tar* | wc -l )
if [ "$tarNum" -eq 0 ];then
    echo -e $TOP_MARK
    echo " there has no package to use. please check!!! "
    echo -e $BOTTOM_MARK
    exit 1
fi

echo -e $TOP_MARK
for (( i=1; i<=${tarNum}; i++ ))
do
    tname=$( ls mysql*.tar* | sed -n "${i}p" )
    echo " ${tname} --- $i"
done
echo -e $BOTTOM_MARK
read -p "  please chose whitch mysql version u want to install:  " vidx

if [ "$vidx" -gt "$tarNum" ];then
    echo -e $TOP_MARK
    echo " please input a right num "
    echo -e $BOTTOM_MARK
    exit 1
fi

tarname=$( ls mysql*.tar* | sed -n "${vidx}p" )
sourcedir=${tarname%.tar*}

if [ ! -f "$tarname" ];then
    echo -e $TOP_MARK
    echo " the $tarname is not exists in $SRC_MYSQL_PATH"
    echo -e $BOTTOM_MARK
    exit 1
fi

#set the mysql root passwd
echo -e $TOP_MARK
read -p " please input the mysql root passwd: " passwd
echo -e "$BR  ur mysql root passwd is: "$passwd"$BR"
read -p " please input [yes] to continue or [no] to exit: " isY
if [ "$isY" != "yes" ];then
    echo " u chose to exit "
    echo -e "$BR   mysql installed failed. Bye ^_^   "
    echo -e $BOTTOM_MARK
    exit 1
else
    echo -e "$BR   mysql begin to install... "
    echo -e $BOTTOM_MARK
    sleep 2
fi

#check group and user
uEx=$( cat /etc/passwd | grep mysql )
gEx=$( cat /etc/group | grep mysql )

if [ "$gEx" != "" ];then
    groupdel mysql
fi

if [ "$uEx" != "" ];then
    userdel mysql
fi

groupadd mysql
useradd -r -g mysql mysql

#begin to install
rm -rf $sourcedir
tar -xzvf $tarname
cd $sourcedir

cmake -DCMAKE_INSTALL_PREFIX="$MYSQL_INSTALL_PATH" \
-DMYSQL_DATADIR="$MYSQL_INSTALL_PATH"/data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci

if [ $CPU_NUM -gt 1 ]; then
    make -j$CPU_NUM
else
    make
fi
make install


#copy the configure file to /etc
cp "$MYSQL_INSTALL_PATH"/support-files/my-default.cnf /etc/my.cnf

#change the permission of mysql dir and mysql-data dir
chown -R root:mysql "$MYSQL_INSTALL_PATH"
chown -R mysql:mysql "$MYSQL_INSTALL_PATH"/data


#create the default database
"$MYSQL_INSTALL_PATH"/scripts/mysql_install_db --basedir="$MYSQL_INSTALL_PATH" --datadir="$MYSQL_INSTALL_PATH"/data --user=mysql

#add the start file into bootitem
cp "$MYSQL_INSTALL_PATH"/support-files/mysql.server /etc/init.d/mysql

chkconfig mysql on

echo export PATH="$MYSQL_INSTALL_PATH"/bin:"$PATH" >> /etc/profile
source  /etc/profile

#start mysql and set the root passwd
service mysql start
if [ $? -eq 0 ]; then
    mysqladmin -u root password "$passwd"
else
    echo -e $TOP_MARK
    echo "       mysql start faild  "
    echo " u can check the err log to find out how it be happend, the log dir is in: ${MYSQL_INSTALL_PATH}/data "
    echo " the mysql root password now is empty. If u want to change the root password u can run the command: mysqladmin -u root password '******' "
    echo -e $BOTTOM_MARK
    echo -e $BR
fi

#write install log
echo -e $TOP_MARK >> "$MYSQL_INSTALL_LOG"
echo " mysql install path is: $MYSQL_INSTALL_PATH" >> "$MYSQL_INSTALL_LOG"
echo " mysql configure path is: /etc/my.cnf" >> "$MYSQL_INSTALL_LOG" 
echo " mysql root passwd is: $passwd" >> "$MYSQL_INSTALL_LOG" 
echo " mysql had add into the chkconfig, u can use the command: service mysql start/stop/restart to control it " >> "$MYSQL_INSTALL_LOG" 
echo -e $BR >> "$MYSQL_INSTALL_LOG"
echo "   mysql installed successed. Bye ^_^   " >> "$MYSQL_INSTALL_LOG"
echo -e $BOTTOM_MARK >> "$MYSQL_INSTALL_LOG"

#print the success message
echo -e $TOP_MARK
echo -e "$BR   mysql installed successed  ^_^   "
echo -e $BOTTOM_MARK
exit 0

##-------------------------------------------------EOF
