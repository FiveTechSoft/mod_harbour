mod_harbour for Raspberry pi

Actualizacion Mayo 29 del 2019 10:00pm Hr de la montana USA

Inicie todo de nuevo...

Borre tres folders o carpetas: temp ,  mod_harbour y  harbour_for_modharbour

He iniciamos todo de nuevo

<br>Instrucciones para crear mod_harbour.so</br>

Esta instruccion ya no lo hize en la segunda actualizacion, solo la primera vez

sudo apt install apache2-dev

mkdir temp

cd temp
apxs -g -n harbour

cd harbour

make all

git clone https://github.com/fivetechsoft/mod_harbour

Si ya estaba instalado

entre a mod_harbour 

y ejecute 

git pull

cp  /linux/mod_harbour.c /temp/harbour 

cd ./temp/harbour

make all

( Ya tienes el mod_harbour.so para Raspberry pi !!!)

Luego vamos a hora a clonar 

git clone https://github.com/fivetechsoft/harbour_for_modharbour

Definimos dos variables de ambiente

export HB_BUILD_CONTRIBS=no

export HB_USER_PRGFLAGS=-I-

cd harbour_for_modharbour

make

y lo utimo es subir los archivos al git

Espero que sirva.

Saludos









