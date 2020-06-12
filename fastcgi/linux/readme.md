In /etc/apache2/apache2.conf add these lines

```
LoadModule fcgid_module /usr/lib/apache2/modules/mod_fcgid.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler fcgid-script
    Options +ExecCGI
    FcgidWrapper /usr/bin/harbour/modharbour
    Order allow,deny
    Allow from all
</FilesMatch>
```
