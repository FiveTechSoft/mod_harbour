[![](https://bitbucket.org/fivetech/screenshots/downloads/fivetech_logo.gif)](http://www.fivetechsoft.com "FiveTech Software")

**How to install mod_harbour:**

Copy libharbour.so.3.2.0 to /var/www/html

Copy mod_harbour.so to /usr/lib/apache2/modules

In /etc/apache2/apache2.conf add these lines:
```
LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so
<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```
Restart apache doing this: 

sudo apachectl restart

Copy samples/test.prg to /var/www/html and go to localhost/test.prg in your browser

***

[![](https://bitbucket.org/fivetech/screenshots/downloads/harbour.jpg)](https://harbour.github.io "The Harbour Project")
<a href="https://httpd.apache.org/" alt="The Apache HTTP Server Project"><img width="150" height="150" src="http://www.apache.org/img/support-apache.jpg"></a>
