[![](https://bitbucket.org/fivetech/screenshots/downloads/fivetech_logo.gif)](http://www.fivetechsoft.com "FiveTech Software")

**How to install mod_harbour:**

```
git clone https://github.com/fivetechsoft/mod_harbour
cd /var/www/html
sudo ln -sf ~/mod_harbour/linux/libharbour.so.3.2.0 libharbour.so.3.2.0
sudo ln -sf ~/mod_harbour/samples modharbour_samples
cd /usr/lib/apache2/modules
sudo ln -sf ~/mod_harbour/linux/mod_harbour.so mod_harbour.so
```

Copy mod_harbour.so to /usr/lib/apache2/modules

In /etc/apache2/apache2.conf add these lines:
```
LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so
<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```
Restart apache doing this: 

sudo apachectl restart

Copy samples/test.prg to /var/www/html and go to localhost/test.prg in your browser

<hr>

**How to build mod_harbour:**

You need to install these Linux packages:
```
sudo apt install libcurl4-openssl-dev
sudo apt install libssl-dev
sudo cp -r /usr/include/x86_64-linux-gnu/curl /usr/include
```

First of all, build Harbour
```
git clone https://github.com/harbour/core harbour
cd harbour
export HB_USER_CFLAGS="-fPIC"
export HB_BUILD_CONTRIBS
make
```
Install apache and apache2-dev
```
sudo apt install apache2
sudo apt install apache2-dev
```
then give execution permissions to go.sh and execute it:
```
chmod +x go.sh
./go.sh
```
Once built, do this:
```
cd /var/www/html
sudo ln -sf ~/mod_harbour/linux/libharbour.so.3.2.0 libharbour.so.3.2.0
sudo ln -sf ~/mod_harbour/samples modharbour_samples
```
copy mod_harbour.so to the Apache modulesudo service apache2 restarts folder:
```
sudo mv mod_harbour.so /usr/lib/apache2/modules
```
and restart apache
```
sudo systemctl restart apache2

or

sudo service apache2 restart
```

Then from your browser go to:
```
localhost/modharbour_samples
```
In case you get a wrong behavior, please check:
```
/var/log/apache2/error.log
```

***

[![](https://bitbucket.org/fivetech/screenshots/downloads/harbour.jpg)](https://harbour.github.io "The Harbour Project")
<a href="https://httpd.apache.org/" alt="The Apache HTTP Server Project"><img width="150" height="150" src="http://www.apache.org/img/support-apache.jpg"></a>
