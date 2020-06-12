Copy mod_fcgid.so to c:\Apache24\modules\mod_fcgid.so

Copy modharbour.exe to c:\Apache24/bin/modharbour.exe

Add these lines at the bottom of c:\Apache24\conf\httpd.conf

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
