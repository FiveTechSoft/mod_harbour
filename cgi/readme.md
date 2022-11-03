Copy this file .htaccess to c:\Apache\htdocs
```
# Harbour - forward all request to modharbour.exe

RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)\.prg$ /cgi-bin/modharbour.exe?$1.prg [L,QSA]

RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^\.]+)$ /cgi-bin/modharbour.exe?$1.prg [L,QSA]
```

And include this in httpd.conf
```
<Directory C:/apache/htdocs>
  RewriteEngine on
  RewriteRule ^([a-zA-Z]*)$ /cgi-bin/modharbour.exe?prg=$1 [NC,QSA]
</Directory>
```
