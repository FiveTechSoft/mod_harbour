Estos ficheros son necesarios para hacer funcionar el módulo en Ubuntu 19.04:

/etc/apache2/mods-available/mod_harbour.load
/etc/apache2/mods-available/mod_harbour.conf

Se hará también un enlace simbólico de estos ficheros a /etc/apache2/mods-enabled

/etc/apache2/mods-available# ln -s mod_harbour.load ../mods-enabled/mod_harbour.load
/etc/apache2/mods-available# ln -s mod_harbour.conf ../mods-enabled/mod_harbour.conf

Contenido de mod_harbour.load
-----------------------------

LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so  // Fijaros que es harbour_module y no mod_harbour

Contenido de mod_harbour.conf
-----------------------------

<IfModule mod_harbour.c>
        <FilesMatch "\.(prg)$">
                SetHandler harbour
        </FilesMatch>
</IfModule>


Para habilitar el módulo ejecutamos el siguiente comando: a2enmod mod_harbour


La librería libharbour.so.3.2.0 está ubicada en /usr/lib/x86_64-linux-gnu/libharbour.so.3.2.0

La librería mod_harbour.so está ubicada en /usr/lib/apache2/modules/mod_harbour.so

La librería lib libmysqlclient en /usr/lib/x86_64-linux-gnu/libmysqlclient.so.20

