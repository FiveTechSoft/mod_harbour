sudo apt-get update -y
sudo apt-get install apache2 -y
sudo apt-get install mysql-server -y
sudo apt-get install libmysqlclient-dev -y
cwd=$(pwd)
cd /var/www/html
sudo ln -sf $cwd/linux/"Ubuntu 18.04"/libharbour.so.3.2.0 libharbour.so.3.2.0
sudo ln -sf $cwd/samples modharbour_samples
cd /usr/lib/apache2/modules
sudo ln -s $cwd/linux/"Ubuntu 18.04"/mod_harbour.so mod_harbour.so
cd $cwd
echo 'LoadModule harbour_module /usr/lib/apache2/modules/mod_harbour.so' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo '<FilesMatch "\.(prg)$">' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo 'SetHandler harbour' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
echo '</FilesMatch>' | sudo tee -a /etc/apache2/apache2.conf > /dev/null
sudo apachectl restart
