
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile
	$(MAKE) -f objs/Makefile manpage

install:
	$(MAKE) -f objs/Makefile install

upgrade:
	/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --pid-path=/usr/local/nginx/logs/nginx.pid --with-http_ssl_module --with-pcre=/home/koma/ATInstall/src/lib/pcre-8.34 --with-zlib=/home/koma/ATInstall/src/lib/zlib-1.2.8 --with-openssl=/home/koma/ATInstall/src/lib/openssl-1.0.1j/sbin/nginx -t

	kill -USR2 `cat /usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --pid-path=/usr/local/nginx/logs/nginx.pid --with-http_ssl_module --with-pcre=/home/koma/ATInstall/src/lib/pcre-8.34 --with-zlib=/home/koma/ATInstall/src/lib/zlib-1.2.8 --with-openssl=/home/koma/ATInstall/src/lib/openssl-1.0.1j/logs/nginx.pid`
	sleep 1
	test -f /usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --pid-path=/usr/local/nginx/logs/nginx.pid --with-http_ssl_module --with-pcre=/home/koma/ATInstall/src/lib/pcre-8.34 --with-zlib=/home/koma/ATInstall/src/lib/zlib-1.2.8 --with-openssl=/home/koma/ATInstall/src/lib/openssl-1.0.1j/logs/nginx.pid.oldbin

	kill -QUIT `cat /usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --pid-path=/usr/local/nginx/logs/nginx.pid --with-http_ssl_module --with-pcre=/home/koma/ATInstall/src/lib/pcre-8.34 --with-zlib=/home/koma/ATInstall/src/lib/zlib-1.2.8 --with-openssl=/home/koma/ATInstall/src/lib/openssl-1.0.1j/logs/nginx.pid.oldbin`
