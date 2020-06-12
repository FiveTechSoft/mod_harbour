```
LoadModule fcgid_module c:\Apache24\modules\mod_fcgid.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler fcgid-script
    Options +ExecCGI
    FcgidWrapper c:\Apache24/bin/modharbour.exe
    Order allow,deny
    Allow from all
</FilesMatch>
```
