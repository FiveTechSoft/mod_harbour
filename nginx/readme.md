1. git clone https://github.com/nginx/nginx

2. cd nginx

3. mkdir objs/lib

4. git clone git://git.openssl.org/openssl objs/lib/openssl

5. git clone https://github.com/rivy/PCRE objs/lib/pcre-8.40

6. git clone https://github.com/madler/zlib objs/lib/zlib-1.2.11



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
