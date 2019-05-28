sudo apt-get update -y
sudo apt-get install apache2 -y
sudo cp ./mod_harbour/linux/"Ubuntu 18.04"/20190528/mod_harbour.so /usr/lib/apache2/modules
sudo cp ./mod_harbour/linux/"Ubuntu 18.04"/20190528/libharbour.so.3.2.0 /var/www/html
echo 'LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo '<FilesMatch "\.(prg)$">' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo 'SetHandler harbour' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo '</FilesMatch>' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
sudo cp ./mod_harbour/samples/test.prg /var/www/html
sudo cp ./mod_harbour/samples/info.prg /var/www/html
sudo apachectl restart
