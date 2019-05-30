mod_harbour for Raspberry pi

Actulizacion Mayo 29 de Mayo 2019 10:00pm Hr montanosa USA

Como comentario en testa segunda actualizacion despues de tres dias

Borre el folder de temp , el folder de mod_harbour y el folder harbour_for_modharbour

e inicie todo de nuevo


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
