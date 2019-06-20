[![](https://bitbucket.org/fivetech/screenshots/downloads/fivetech_logo.gif)](http://www.fivetechsoft.com "FiveTech Software")

These instructions are to build the mod and the libharbour.so.3.2.0 files. If you simply want to test them
without having to build them, select your Linux distribution, download the two files and follow these steps:

Copy libharbour.so.3.2.0 to /var/www/html

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

**Instructions to build them (skip this if you just want to test it without build them)**

The mod_harbour for Apache on Linux uses a different approach that turns it much much faster and lighter.

This is the required structure of folders to create mod_harbour:
```
 + /home/username
   + mod_harbour
   + harbour_for_modharbour
   + temp
      + harbour  (created using apxs -g -n harbour from temp folder)
```

**0. Changes to build Harbour:**

In both **config/dyn.mk** and **config/lib.mk** HB_DYN_LIBS add hbcplr \

In **src/Makefile** DYNDIRLIST_BASE add src/compiler \

In **src/harbour.def** add HB_FUN_HB_COMPILEFROMBUF

Copy **apache.prg** to src/rtl and modify Makefile to add it in PRG_SOURCES section

If you want to have sources line numbers do this before calling make:

export HB_USER_PRGFLAGS=-l-

Correct libharbour.so.3.2.0 size should be around 6.262.832

**1. It has been built using the Windows 10 bash:**

https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/

**2. Install this from the Windows 10 bash:**

sudo apt-get install apache2-dev

**3. go to /home/<username> and type this:**

apxs -n harbour -g

This will create a harbour folder with all the required files inside it

**4. In order to test this do:**

make all

sudo make install

sudo make test

**5. Copy ~/harbour/lib/linux/gcc/libharbour.so.3.2.0 to /var/www/html**

cp ~/harbour/lib/linux/gcc/libharbour.so.3.2.0 /var/www/html

**6. Now replace your mod_harbour.c with the one provided here and repeat the step 4**

***

[![](https://bitbucket.org/fivetech/screenshots/downloads/harbour.jpg)](https://harbour.github.io "The Harbour Project")
<a href="https://httpd.apache.org/" alt="The Apache HTTP Server Project"><img width="150" height="150" src="http://www.apache.org/img/support-apache.jpg"></a>
