```
<Directory C:/xampp/htdocs>
  RewriteEngine on
  RewriteRule ^([a-zA-Z]*)$ /cgi-bin/mdharbour.exe?$1 [NC,QSA]
</Directory>
```
