**Instructions for both Apache or Xampp:**

Add these lines into httpd.conf:

```
LoadModule harbour_module modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```
If you are using Xampp on Windows then use SetEnv like this from httpd.conf:
```
    SetEnv LIBHARBOUR "c:\xampp\htdocs\libharbour.dll" 
```

Recommended settings are:

```c:\mod_harbour  (created using git clone https://github.com/fivetechsoft/mod_harbour)```

At c:\Apache24\htdocs create these symlinks: (run cmd as administrator)

```mklink /j modharbour_samples c:\mod_harbour\samples```

```mklink /h libharbour.dll c:\mod_harbour\windows\win64\libharbour.dll```

Copy these DLLs (bin folder inside the modharbour zip): https://github.com/FiveTechSoft/mod_harbour/tree/master/windows/win64/required
to c:\Apache24\bin: libcurl-x64.dll, libcrypto-1_1-x64.dll and libssl-1_1-x64.dll
If you are using Xampp, then copy the DLLs to C:\xampp\apache\bin

From the browse go to localhost/modharbour_samples

When you want to update mod_harbour, simply go to mod_harbour and do a git pull
