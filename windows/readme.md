Id you are using Xampp on Windows then use SetEnv like this:

```
LoadModule harbour_module modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetEnv LIBHARBOUR "c:/xampp/htdocs" 
    SetHandler harbour
</FilesMatch>
```
