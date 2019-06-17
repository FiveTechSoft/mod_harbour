cp mod_harbour.so /usr/local/lib/httpd/modules
cd /usr/local/var/www
sudo ln -sf /Users/$USER/mod_harbour/osx/libharbour.3.2.0.dylib libharbour.3.2.0.dylib
sudo ln -sf /Users/anto/mod_harbour/samples modharbour_samples
sudo apachectl restart
