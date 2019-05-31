cd ~
if [ ! -d "mod_harbour" ]; then
   git clone https://github.com/fivetechsoft/mod_harbour
else
   cd mod_harbour
   git pull
fi
if [ ! -d "harbour_for_modharbour" ]; then
   git clone https://github.com/fivetechsoft/harbour_for_modharbour
else
   cd harbour_for_modharbour
   git pull
fi
cd ~/harbour_for_modharbour/src/rtl
ln -s ~/mod_harbour/linux/apache.prg apache.prg  
cd ~/harbour_for_modharbour
export HB_USER_PRGFLAGS=-l-
export HB_BUILD_CONTRIBS=no
make
cd /var/www/html
ln -s ~/harbour_for_modharbour/lib/linux/gcc/libharbour.so.3.2.0 libharbour.so.3.2.0
ln -s ~/harbour_for_modharbour/samples mod_harbour_samples
cd ~/mod_harbour/linux/"Ubuntu 18.04"
ln -s ~/harbour_for_modharbour/lib/linux/gcc/libharbour.so.3.2.0 libharbour.so.3.2.0
cp ~/mod_harbour/samples/* /var/www/html
sudo apachectl restart
cd ~/mod_harbour
git pull
git commit /linux/"Ubuntu 18.04"/libharbour.so.3.2.0 -m"new build"
git push
