He cambiado la línea:

pLib = hb_LibLoad( "/usr/lib/x86_64-linux-gnu/libmysqlclient.so" ) // libmysqlclient.so.20 for mariaDB

por

pLib = hb_LibLoad( "/usr/lib64/libmysqlclient.so" ) // libmysqlclient.so.20 for mariaDB

