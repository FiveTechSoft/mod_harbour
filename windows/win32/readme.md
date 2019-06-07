**Quick setup**

copy mod_harbour.so into c:\Apache24\modules\

copy libharbour.dll into c:\Apache24\htdocs\

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
