If you are using Xampp on Windows then use SetEnv like this from httpd.conf:

```
LoadModule harbour_module modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetEnv LIBHARBOUR "c:/xampp/htdocs" 
    SetHandler harbour
</FilesMatch>
```

Recommended settings are:

```c:\mod_harbour  (created using git clone https://github.com/fivetechsoft/mod_harbour)```

At c:\Apache24\htdocs create these symlinks: (run cmd as administrator)

```mklink /j modharbour_samples c:\mod_harbour\samples```

```mklink /h libharbour.dll c:\mod_harbour\windows\win64\libharbour.dll```

From the browse go to localhost/modharbour_samples

When you want to update mod_harbour, simply go to mod_harbour and do a git pull
