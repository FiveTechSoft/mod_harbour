These files are needed to mod works on Ubuntu 19.04:

/etc/apache2/mods-available/mod_harbour.load
/etc/apache2/mods-available/mod_harbour.conf

We need a symbolic link of these files to /etc/apache2/mods-enabled

/etc/apache2/mods-available# ln -s mod_harbour.load ../mods-enabled/mod_harbour.load
/etc/apache2/mods-available# ln -s mod_harbour.conf ../mods-enabled/mod_harbour.conf

mod_harbour.load's content
--------------------------

LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so  // Notice: is harbour_module not mod_harbour

mod_harbour.conf's content
--------------------------

<IfModule mod_harbour.c>
        <FilesMatch "\.(prg)$">
                SetHandler harbour
        </FilesMatch>
</IfModule>


We need execute a2enmod mod_harbour to enable module

libharbour.so.3.2.0 library s located on /usr/lib/x86_64-linux-gnu/libharbour.so.3.2.0

mod_harbour.so library is located on /usr/lib/apache2/modules/mod_harbour.so

libmysqlclient.so.20 is located on /usr/lib/x86_64-linux-gnu/libmysqlclient.so.20

