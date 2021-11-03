```
<Directory "c:/Apache24/cgi-bin">
    Options +ExecCGI
    SetHandler cgi-script
</Directory>

RewriteEngine on
RewriteRule "^/([a-zA-Z]+)$" "/cgi-bin/modharbour.exe?$1.prg" [NC,PT]
```
