```
<Directory C:/apache/htdocs>
  RewriteEngine on
  RewriteRule ^([a-zA-Z]*)$ /cgi-bin/modharbour.exe?prg=$1 [NC,QSA]
</Directory>
```
