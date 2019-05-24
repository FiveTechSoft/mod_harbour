
Creación de una VM para Harbour y mod_harbour en CentOS 7
=========================================================

- Instalación mínima
- Asignación de IP y nombre
- yum install yum-utils
- yum update
- yum groupinstall "Development tools"
- yum install git-all.noarch
- yum install httpd.x86_64  httpd-devel.x86_64 httpd-tools.x86_64
- yum install epel-release
- Instalar mediante yum todos los paquetes necesarios para crear Harbour, los podéis encontrar en el Wiki https://github.com/FiveTechSoft/harbour_for_modHarbour
- systemctl enable httpd.service
- systemctl start httpd.service
- git clone https://github.com/FiveTechSoft/harbour_for_modHarbour harbour
- git clone https://github.com/FiveTechSoft/mod_harbour mod_harbour
- mkdir temp al mismo nivel que los directorios harbour y mod_harbour en mi caso /root
- cd temp
- apxs -n harbour -g // Nos genera el directorio harbour y en él los ficheros: Makefile, mod_harbour.c, etc ...
- copiamos el fichero mod_harbour.c que tenemos en /root/mod_harbour/linux a /root/temp/harbour
- modificamos el fichero mod_harbour.c, la línea lib_harbour = dlopen( "/var/www/html/libharbour.so.3.2.0", RTLD_LAZY ); por lib_harbour = dlopen( "/usr/lib64/libharbour.so.3.2.0", RTLD_LAZY );
- estando en el directorio /root/temp/harbour ejecutamos el comando apxs -c -i mod_harbour.c que nos creará el mod mod_harbour.so y lo llevará a su sitio
- la librería libharbour.so.3.2.0 tiene que estar en /usr/lib64
- creamos el fichero 01-mod_harbour.conf en el directorio /etc/httpd/conf.modules.d con el siguiente contenido

LoadModule harbour_module modules/mod_harbour.so
        <FilesMatch "\.(prg)$">
                SetHandler harbour
        </FilesMatch>
		
- reiniciamos apache, lo podemos hacer de las siguientes maneras systemctl restart httpd.service o apachectl restart		

Install CentOS 7 vm for harbour and mod_harbour
===============================================

- Minimal installation
- Assign IP and hostname
- yum install yum-utils
- yum update
- yum groupinstall "Development tools"
- yum install git-all.noarch
- yum install httpd.x86_64  httpd-devel.x86_64 httpd-tools.x86_64
- yum install epel-release
- Install all needed packages for Harbour creation via yum, please review https://github.com/FiveTechSoft/harbour_for_modHarbour
- systemctl enable httpd.service
- systemctl start httpd.service
- git clone https://github.com/FiveTechSoft/harbour_for_modHarbour harbour
- git clone https://github.com/FiveTechSoft/mod_harbour mod_harbour
- mkdir temp at the same level of harbour and mod_harbour, in our case /root
- cd temp
- apxs -n harbour -g // This create harbour directory and files: Makefile, mod_harnor.c, etc ...
- copy mod_harbour.c from /root/mod_harbour/linux to /root/temp/harbour
- modify mod_harbour.c file, line lib_harbour = dlopen( "/var/www/html/libharbour.so.3.2.0", RTLD_LAZY ); by lib_harbour = dlopen( "/usr/lib64/libharbour.so.3.2.0", RTLD_LAZY );
- on directory /root/temp/harbour execute command apxs -c -i mod_harbour.c, this create mod_harbour.so file and put it on correct directory
- copy libharbour.so.3.2.0 library to /usr/lib64
- create 01-mod_harbour.conf on /etc/httpd/conf.modules.d with this:

LoadModule harbour_module modules/mod_harbour.so
        <FilesMatch "\.(prg)$">
                SetHandler harbour
        </FilesMatch>
		
- restart Apache with any of these commands, systemctl restart httpd.service or apachectl restart

