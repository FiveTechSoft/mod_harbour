Copy ngx_mod_harbour.so and libharbour.so to /usr/local/nginx/modules

nginx html pages: /usr/share/nginx/html

Stop the server: ~/nginx/objs# ./nginx -s quit

Run it again: ~/nginx/objs# ./nginx

test it: curl http://localhost?test.prg

Install MinGW with msys

We need Perl to compile openssl, we can use Strawberry Perl https://strawberryperl.com/ or ActivePerl https://www.activestate.com/products/perl/

0. cd c:\MinGW\msys\1.0\home\your_user_name

1. git clone https://github.com/nginx/nginx

2. cd nginx

3. mkdir -p objs/lib

4. git clone git://git.openssl.org/openssl objs/lib/openssl  ( https://ftp.openssl.org/source )

5. git clone https://github.com/rivy/PCRE objs/lib/pcre-8.40

6. git clone https://github.com/madler/zlib objs/lib/zlib-1.2.11

7. edit c:\MinGW\msys\1.0\home\anto\nginx\auto\cc\msvc and replace CFLAGS="$CFLAGS -W4" with CFLAGS="$CFLAGS -W3"

8. open a "Developer Command Prompt for VS 2019" (search for Dev... from Windows search)

9. C:\MinGW\msys\1.0\msys.bat

10. cd nginx

11. auto/configure \
--with-cc=cl \
--builddir=objs \
--prefix= \
--conf-path=conf/nginx.conf \
--pid-path=logs/nginx.pid \
--http-log-path=logs/access.log \
--error-log-path=logs/error.log \
--sbin-path=nginx.exe \
--http-client-body-temp-path=temp/client_body_temp \
--http-proxy-temp-path=temp/proxy_temp \
--http-fastcgi-temp-path=temp/fastcgi_temp \
--with-cc-opt=-DFD_SETSIZE=1024 \
--with-pcre=objs/lib/pcre-8.40 \
--with-zlib=objs/lib/zlib-1.2.11 \
--with-openssl=objs/lib/openssl \
--with-openssl-opt=no-asm \
--with-select_module  \
--with-http_ssl_module \

12. return to the "Developer Command Prompt for VS 2019" that is still opened from step 7

13. cd c:\MinGW\msys\1.0\home\your_user_name\nginx

14. nmake

15. C:\MinGW\msys\1.0\msys.bat

16. cd nginx

17. auto/configure
--with-cc=cl
--builddir=objs
--prefix=
--conf-path=conf/nginx.conf
--pid-path=logs/nginx.pid
--http-log-path=logs/access.log
--error-log-path=logs/error.log
--sbin-path=nginx.exe
--http-client-body-temp-path=temp/client_body_temp
--http-proxy-temp-path=temp/proxy_temp
--http-fastcgi-temp-path=temp/fastcgi_temp
--with-cc-opt=-DFD_SETSIZE=1024
--with-pcre=objs/lib/pcre-8.44
--with-zlib=objs/lib/zlib-1.2.11
--with-openssl=objs/lib/openssl
--with-openssl-opt=no-asm
--with-select_module
--with-http_ssl_module 
--with-compat --add-dynamic-module=c:/mod_harbour/nginx

objs/ngx_mod_harbour.so:	objs/addon/nginx/ngx_mod_harbour.o \
	objs/ngx_mod_harbour_modules.o \
	objs/lib/pcre-8.40/.libs/libpcre.a \
	objs/lib/zlib-1.2.11/libz.a
	$(LINK) -o objs/ngx_mod_harbour.so \
	objs/addon/nginx/ngx_mod_harbour.o \
	objs/ngx_mod_harbour_modules.o \
	advapi32.lib ws2_32.lib objs/lib/pcre-8.40/.libs/libpcre.a objs/lib/zlib-1.2.11/libz.a \
	-shared


objs/ngx_mod_harbour_modules.o:	$(CORE_DEPS) \
	objs/ngx_mod_harbour_modules.c
	$(CC) -c  $(CFLAGS) $(ALL_INCS) \
		-o objs/ngx_mod_harbour_modules.o \
		objs/ngx_mod_harbour_modules.c


objs/addon/nginx/ngx_mod_harbour.o:	$(ADDON_DEPS) \
	~/mod_harbour/nginx/ngx_mod_harbour.c
	$(CC) -c  $(CFLAGS) $(ALL_INCS) \
		-o objs/addon/nginx/ngx_mod_harbour.o \
		~/mod_harbour/nginx/ngx_mod_harbour.c

https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/

http://nginx.org/en/download.html

https://github.com/perusio/nginx-hello-world-module/blob/master/ngx_http_hello_world_module.c

https://trac.nginx.org/nginx/browser/nginx/src#core

https://stackoverflow.com/questions/21486482/compile-nginx-with-visual-studio

https://www.evanmiller.org/nginx-modules-guide.html

In NGINX 1.9.11 onwards a new way of loading modules dynamically has been introduced. This means that selected modules can be loaded into NGINX at runtime based on configuration files. They can also be unloaded by editing the configuration files and reloading NGINX

https://www.nginx.com/resources/wiki/extending/converting/

~/nginx$ ./auto/configure --add-dynamic-module=~/mod_harbour/nginx

https://github.com/tjliupeng/nginx-build-windows

https://amefs.net/en/archives/1935.html

https://forum.nginx.org/

**Building on Linux**

~/nginx$ auto/configure --with-compat --add-dynamic-module=/home/anto/mod_harbour/nginx

make (or make modules)

copy ngx_mod_harbour.so to /usr/local/nginx/modules

copy nginx.conf to /usr/local/nginx/conf

./nginx -s quit 

./nginx

https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/
