mod_harbour for Raspberry pi

<br>Instrucciones para crear mod_harbour.so</br>

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
