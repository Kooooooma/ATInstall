# ATInstall
This is an auto install shell script for automatic install the LAMP, LN(T)MP in linux system.  
**——create by Koma**

# Main features:

* Install LAMP/LNMP/LT(Tengine)MP automatic
* Chose the package version by urself, only u need to do is put the defferent version tar-package into the ***src*** directory
* Support install Mysql,PHP,Nginx,Tengine only
* Add the service into the system boot list when install is done
* Control easily, just use this one command: ***service nginx/mysql/php-fpm start/stop/restart***

# Future features:

* Install the nginx extension automatic (This is what am i doing now)
* Install the Sphinx+coreseek automatic
* Install the NoSql package automatic

# Attentions:

When the script is run, first it will ask u to install the common depend package, u can input [yes] or [no] to decide what u want to do, i wanner to say is that the install common package script is in the ***commonPackageInstall.sh*** script file, this file use the yum command to install all the package, if ur system doesn't support the command u can edit it and change the command that ur own system can understand the command u have send!

__For ur first to use it, u'd better to read the tips careful!__

# useage：

```bash
su root
git clone https://github.com/KomaBeyond/ATInstall.git
cd ATInstall
./install.sh
```

---

__At last, happy for ur life!__
