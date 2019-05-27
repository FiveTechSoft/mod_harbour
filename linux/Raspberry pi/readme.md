mod_harbour for Raspberry pi

(Importante, tener cuenta con GIT)

Instrucciones:

1.- instalar apache
  sudo apt install apache2-dev
2.- crear una carpeta temp
  mkdir temp
  cd temp
3.- Ejecutar
  apxs -g -n harbour
4.- cd harbour
  make all

Si todo hasta aqui funciona, continuamos

1.- Clonar el proyecto
  git clone https://github.con/fivetechsoft/mod_harbour
  
