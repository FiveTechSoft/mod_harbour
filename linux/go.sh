sudo apt-get update -y
sudo apt-get install apache2 -y
sudo apt-get install mysql-server -y
sudo apt-get install libmysqlclient-dev -y
cd /var/www/html
sudo ln -sf ~/mod_harbour/linux/"Ubuntu 18.04"/libharbour.so.3.2.0 libharbour.so.3.2.0
sudo ln -sf ~/mod_harbour/samples modharbour_samples
cd ..
sudo mkdir test
sudo cp ~/mod_harbour/samples/customer.dbf ./test
sudo chmod 0777 ./test
sudo chown www-data:www-data ./test
sudo chmod 0777 ./test/customer.dbf
rm ~/mod_harbour/samples/customer.dbf
cd /usr/lib/apache2/modules
sudo ln -sf ~/mod_harbour/linux/"Ubuntu 18.04"/mod_harbour.so mod_harbour.so
cd ~
echo 'LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo '<FilesMatch "\.(prg|hrb)$">' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo 'SetHandler harbour' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo '</FilesMatch>' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
sudo apachectl restart
