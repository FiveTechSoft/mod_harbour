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
cd ~/mod_harbour
cp ./linux/“Ubuntu 18.04”/apache.prg  ~/harbour_for_modharbour/src/rtl
cd ~/harbour_for_modharbour
export HB_USER_PRGFLAGS=-l-
export HB_BUILD_CONTRIBS=no
make
cp ./lib/linux/gcc/libharbour.so.3.2.0 /var/www/html
cp ./lib/linux/gcc/libharbour.so.3.2.0 ~/mod_harbour/linux/"Ubuntu 18.04"
cd ~/mod_harbour
git pull
git commit /linux/"Ubuntu 18.04"/libharbour.so.3.2.0 -m"new build"
git push
