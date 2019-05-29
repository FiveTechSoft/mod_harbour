cp apache.prg  ~/harbour_for_modharbour/src/rtl
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
