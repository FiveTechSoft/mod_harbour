Copy mod_fcgid.so to c:\Apache24\modules\mod_fcgid.so

Copy modharbour.exe to c:\Apache24/bin/modharbour.exe

Copy libfcgi.dll to c:\Apache24/bin/libfcgi.dll. 

Also copy libcrypto-1_1-x64.dll, libcurl-x64.dll and libssl-1_1-x64.dll to c:\Apache24\bin.
If needed, then also install VC_redist.x64.exe

Add these lines at the bottom of c:\Apache24\conf\httpd.conf

```
LoadModule fcgid_module modules/mod_fcgid.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler fcgid-script
    Options +ExecCGI
    FcgidWrapper c:/Apache24/bin/modharbour.exe
</FilesMatch>
```
