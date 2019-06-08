cd ~
if [ ! -d "mod_harbour" ]; then
   git clone https://github.com/fivetechsoft/mod_harbour
else
   cd mod_harbour
   git pull
   cd ..
fi
if [ ! -d "harbour_for_modharbour" ]; then
   git clone https://github.com/fivetechsoft/harbour_for_modharbour
else
   cd harbour_for_modharbour
   git pull
   cd ..
fi
if [ ! -d "temp" ]; then
   mkdir temp
fi
cd temp
if [ ! -d "harbour" ]; then
   apxs -g -n harbour
fi   
cd harbour
ln -sf ~/mod_harbour/linux/mod_harbour.c mod_harbour.c
make all
cd ~/harbour_for_modharbour/src/rtl
ln -sf ~/mod_harbour/linux/apache.prg apache.prg  
cd ~/harbour_for_modharbour
export HB_USER_PRGFLAGS=-l-
export HB_BUILD_CONTRIBS=no
make
cd /var/www/html
sudo ln -sf ~/harbour_for_modharbour/lib/linux/gcc/libharbour.so.3.2.0 libharbour.so.3.2.0
sudo ln -sf ~/mod_harbour/samples mod_harbour_samples
cd ~/mod_harbour/linux/"Ubuntu 18.04"
ln -sf ~/harbour_for_modharbour/lib/linux/gcc/libharbour.so.3.2.0 libharbour.so.3.2.0
cd /usr/lib/apache2/modules
sudo ln -sf ~/mod_harbour/linux/"Ubuntu 18.04"/mod_harbour.so mod_harbour.so
sudo apachectl restart
cd ~/mod_harbour
git pull
#git commit /linux/"Ubuntu 18.04"/libharbour.so.3.2.0 -m"new build"
#git push
