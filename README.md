[![](https://bitbucket.org/fivetech/screenshots/downloads/fivetech_logo.gif)](http://www.fivetechsoft.com "FiveTech Software")

# mod_harbour
Apache mod for Harbour

https://httpd.apache.org/docs/2.4/developer/modguide.html

Download Apache from here:

https://home.apache.org/~steffenal/VC15/binaries/httpd-2.4.39-win64-VC15.zip

Copy mod_harbour.so to c:\Apache24\modules\mod_harbour.so

In c:\Apache24\conf\httpd.conf add these lines:

LoadModule harbour_module modules/mod_harbour.so

...

AddHandler harbour-handler .prg    (after < /Directory>)


***
[![](https://bitbucket.org/fivetech/screenshots/downloads/harbour.jpg)](https://harbour.github.io "The Harbour Project")
