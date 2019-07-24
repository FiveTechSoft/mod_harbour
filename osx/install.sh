echo Installing mod_harbour for OSX...
sudo mkdir -p /usr/local/httpd/modules
cd /usr/local/httpd/modules
sudo ln -sf /Users/$USER/mod_harbour/osx/mod_harbour.so mod_harbour.so
cd /Library/WebServer/Documents
sudo ln -sf /Users/$USER/mod_harbour/osx/libharbour.3.2.0.dylib libharbour.3.2.0.dylib
sudo ln -sf /Users/$USER/mod_harbour/samples modharbour_samples
echo 'LoadModule harbour_module /usr/local/httpd/modules/mod_harbour.so' | sudo tee -a /private/etc/apache2/httpd.conf > /dev/null
echo '<FilesMatch "\.(prg|hrb)$">' | sudo tee -a /private/etc/apache2/httpd.conf > /dev/null
echo 'SetHandler harbour' | sudo tee -a /private/etc/apache2/httpd.conf > /dev/null
echo '</FilesMatch>' | sudo tee -a /private/etc/apache2/httpd.conf > /dev/null
echo 'Options Indexes FollowSymLinks Multiviews'| sudo tee -a /private/etc/apache2/httpd.conf > /dev/null
cd /Users/$USER/mod_harbour
sudo chown -R _www:_www samples
sudo apachectl restart
echo Please go to localhost/modharbour_samples from your web browser
