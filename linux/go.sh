sudo apt-get update -y
sudo apt-get install apache2 -y
sudo cp ./mod_harbour/linux/"Ubuntu 18.04"/mod_harbour.so /usr/lib/apache2/modules
sudo cp ./mod_harbour/linux/"Ubuntu 18.04"/libharbour.so.3.2.0 /var/www/html
echo echo 'LoadModule harbour_module modules/mod_harbour.so' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo echo '<FilesMatch "\.(prg)$">' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo echo 'SetHandler harbour' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo echo '</FilesMatch>' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
sudo cp ./mod_harbour/linux/test.prg /var/www/html
sudo apachectl restart
