**Quick setup**

copy mod_harbour.so into c:\Apache24\modules\

copy libharbour.dll into c:\Apache24\htdocs\

for 32 bits, please copy these DLLs also where libharbour.dll is placed:
(These DLLs names appear in the Harbour building log)
c:\OpenSSL-Win32\libeay32.dll 
c:\OpenSSL-Win32\ssleay32.dll 
c:\curl\bin\libcurl.dll

Add these into c:\Apache24\conf\httpd.conf

```
LoadModule harbour_module modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```

Start c:\Apache24\bin\httpd.exe

For easy of testing, create a folder "c:\Apache24\htdocs\modharbour_examples\" and copy all mod_harbour samples *.prg there

From your web browser go to: localhost/modharbour_examples
