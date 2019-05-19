sudo apt-get update -y
sudo apt-get install apache2 -y
git clone https://github.com/fivetechsoft/mod_harbour
sudo cp ./mod_harbour/linux/Ubuntu 18.04/mod_harbour.so /usr/lib/apache2/modules
sudo cp ./mod_harbour/linux/Ubuntu 18.04/libharbour.so.3.2.0 /var/www/html

