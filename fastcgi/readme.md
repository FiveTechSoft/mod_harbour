mod_harbour + fastCGI offer the fastest mod_harbour performance

mod_harbour acts as a server, always running, interacting with fastCGI

requests per seconds reach values around 95 or even higher. You can test it this way from Windows:

c:\Apache24\bin\ab.exe -n 100 -c 20 localhost/modharbour_samples/test.prg

https://fastcgi-archives.github.io/

http://httpd.apache.org/mod_fcgid/

http://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html

http://cgi.sourceforge.net/docs/fastcgi___cgi/examples/cgi_examples.html#fastcgi___cgi.examples.cgi_examples.hello_world

git clone https://github.com/VisualAwarenessTech/fcgi-2.4.1

Special thanks to Eric Lendai for opening our eyes towards FastCGI !
